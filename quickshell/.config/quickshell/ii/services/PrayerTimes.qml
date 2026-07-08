pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.modules.common
import qs.services

Singleton {
    id: root

    property var prayers: []
    property string nextPrayerName: ""
    property string nextPrayerTime: ""
    property string locationLabel: Translation.tr("Location not set")
    property bool hasValidLocation: false

    Timer {
        id: refreshTimer
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshPrayers()
    }

    function refreshPrayers() {
        const coords = getLocation();
        hasValidLocation = coords.valid;
        locationLabel = coords.valid
            ? (coords.name || `${coords.lat.toFixed(2)}, ${coords.lon.toFixed(2)}`)
            : Translation.tr("Set location coordinates in settings");

        if (!coords.valid) {
            prayers = [];
            nextPrayerName = "";
            nextPrayerTime = "";
            return;
        }

        const now = DateTime.clock.date;
        const timezone = -now.getTimezoneOffset() / 60;
        const settings = Config.options.sidebar.prayer;
        const rawTimes = calculatePrayerTimes(now, coords.lat, coords.lon, timezone, settings.fajrAngle, settings.ishaAngle, settings.asrFactor);
        const prayerList = buildPrayerList(rawTimes, now);

        prayers = prayerList;
        const highlighted = prayerList.find(item => item.isNext);
        nextPrayerName = highlighted ? highlighted.name : "";
        nextPrayerTime = highlighted ? highlighted.time : "";
    }

    function getLocation() {
        const config = Config.options.sidebar.prayer;
        let lat = config.latitude;
        let lon = config.longitude;
        let name = config.locationName || "";

        if (config.useWeatherLocation && Weather.location.valid) {
            lat = Weather.location.lat;
            lon = Weather.location.long;
            name = Weather.data && Weather.data.city ? Weather.data.city : name;
            return { lat: lat, lon: lon, name: name, valid: isValidLatLon(lat, lon) };
        }

        const manualOk = config.useManualCoordinates && isConfiguredManualLocation(lat, lon, name) && isValidLatLon(lat, lon);
        return {
            lat: lat,
            lon: lon,
            name: name,
            valid: manualOk
        };
    }

    function isConfiguredManualLocation(lat, lon, name) {
        // Prevent accidental fallback to the default (0, 0) unless user intentionally set a named location.
        return (Math.abs(lat) > 0.000001 || Math.abs(lon) > 0.000001 || name.trim().length > 0);
    }

    function isValidLatLon(lat, lon) {
        if (typeof lat !== "number" || typeof lon !== "number") return false;
        if (isNaN(lat) || isNaN(lon)) return false;
        return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;
    }

    function buildPrayerList(times, now) {
        const entries = [
            { key: "fajr", name: Translation.tr("Fajr") },
            { key: "dhuhr", name: Translation.tr("Dhuhr") },
            { key: "asr", name: Translation.tr("Asr") },
            { key: "maghrib", name: Translation.tr("Maghrib") },
            { key: "isha", name: Translation.tr("Isha") }
        ];

        const nowSeconds = now.getHours() * 3600 + now.getMinutes() * 60 + now.getSeconds();
        const list = entries.map(entry => {
            const raw = times[entry.key];
            const normalized = isNaN(raw) ? NaN : fixHour(raw);
            const seconds = isNaN(normalized) ? NaN : Math.round(normalized * 3600);
            return {
                name: entry.name,
                time: formatTime(normalized),
                seconds: seconds,
                isNext: false
            };
        });

        const validPrayers = list.filter(item => !isNaN(item.seconds));
        if (validPrayers.length > 0) {
            let next = validPrayers.find(item => item.seconds >= nowSeconds);
            if (!next)
                next = validPrayers[0];
            list.forEach(item => {
                item.isNext = next && item.name === next.name;
            });
        }

        return list;
    }

    function formatTime(value) {
        if (isNaN(value))
            return Translation.tr("--:--");
        const totalMinutes = Math.round(value * 60);
        let hours = Math.floor(totalMinutes / 60);
        let minutes = totalMinutes - hours * 60;
        while (minutes < 0) {
            minutes += 60;
            hours -= 1;
        }
        while (minutes >= 60) {
            minutes -= 60;
            hours += 1;
        }
        const normalizedHours = ((hours % 24) + 24) % 24;
        return `${padZero(normalizedHours)}:${padZero(minutes)}`;
    }

    function padZero(value) {
        const text = Math.abs(value).toString();
        return text.length < 2 ? `0${text}` : text;
    }

    function calculatePrayerTimes(date, lat, lon, timezone, fajrAngle, ishaAngle, asrFactor) {
        const baseTimes = [5, 6, 12, 13, 18, 18, 18];
        const latRad = deg2rad(lat);
        const julianDay = julian(date) - lon / 360;
        const computed = computeTimes(baseTimes.slice(), julianDay, latRad, fajrAngle, ishaAngle, asrFactor);
        const adjusted = adjustTimes(computed, timezone, lon);
        for (let i = 0; i < adjusted.length; i++)
            adjusted[i] = fixHour(adjusted[i]);
        return {
            fajr: adjusted[0],
            sunrise: adjusted[1],
            dhuhr: adjusted[2],
            asr: adjusted[3],
            sunset: adjusted[4],
            maghrib: adjusted[5],
            isha: adjusted[6]
        };
    }

    function computeTimes(times, julianDay, latRad, fajrAngle, ishaAngle, asrFactor) {
        dayPortion(times);
        const fajr = sunAngleTime(-fajrAngle, times[0], -1, latRad, julianDay);
        const sunrise = sunAngleTime(-0.833, times[1], -1, latRad, julianDay);
        const dhuhr = midDay(times[2], julianDay);
        const asr = asrTime(asrFactor, times[3], latRad, julianDay);
        const sunset = sunAngleTime(-0.833, times[4], 1, latRad, julianDay);
        const maghrib = sunset;
        const isha = sunAngleTime(-ishaAngle, times[6], 1, latRad, julianDay);
        return [fajr, sunrise, dhuhr, asr, sunset, maghrib, isha];
    }

    function adjustTimes(times, timezone, lon) {
        const offset = timezone - lon / 15;
        for (let i = 0; i < times.length; i++)
            times[i] += offset;
        return times;
    }

    function dayPortion(times) {
        for (let i = 0; i < times.length; i++)
            times[i] /= 24;
        return times;
    }

    function sunAngleTime(angle, timeFraction, direction, latRad, julianDay) {
        const decl = sunPosition(julianDay + timeFraction).decl;
        const noon = midDay(timeFraction, julianDay);
        const angleRad = deg2rad(angle);
        const term = (Math.sin(angleRad) - Math.sin(latRad) * Math.sin(decl)) / (Math.cos(latRad) * Math.cos(decl));
        if (term < -1 || term > 1)
            return NaN;
        const delta = rad2deg(Math.acos(term)) / 15;
        return noon + direction * delta;
    }

    function asrTime(factor, timeFraction, latRad, julianDay) {
        const decl = sunPosition(julianDay + timeFraction).decl;
        const angle = -Math.atan(1 / (factor + Math.tan(Math.abs(latRad - decl))));
        return sunAngleTime(rad2deg(angle), timeFraction, 1, latRad, julianDay);
    }

    function midDay(timeFraction, julianDay) {
        const eqt = sunPosition(julianDay + timeFraction).eqt;
        return fixHour(12 - eqt);
    }

    function sunPosition(jd) {
        const D = jd - 2451545.0;
        const g = fixAngle(357.529 + 0.98560028 * D);
        const q = fixAngle(280.459 + 0.98564736 * D);
        const L = fixAngle(q + 1.915 * Math.sin(deg2rad(g)) + 0.020 * Math.sin(deg2rad(2 * g)));
        const e = 23.439 - 0.00000036 * D;
        const RA = fixHour(rad2deg(Math.atan2(Math.cos(deg2rad(e)) * Math.sin(deg2rad(L)), Math.cos(deg2rad(L)))) / 15);
        const eqt = q / 15 - RA;
        const decl = Math.asin(Math.sin(deg2rad(e)) * Math.sin(deg2rad(L)));
        return { decl: decl, eqt: eqt };
    }

    function julian(date) {
        let year = date.getUTCFullYear();
        let month = date.getUTCMonth() + 1;
        const day = date.getUTCDate();
        const hour = date.getUTCHours();
        const minute = date.getUTCMinutes();
        const second = date.getUTCSeconds();

        if (month <= 2) {
            year -= 1;
            month += 12;
        }

        const A = Math.floor(year / 100);
        const B = 2 - A + Math.floor(A / 4);
        const dayFraction = (hour + minute / 60 + second / 3600) / 24;
        return Math.floor(365.25 * (year + 4716))
            + Math.floor(30.6001 * (month + 1))
            + day + B - 1524.5 + dayFraction;
    }

    function deg2rad(value) {
        return value * Math.PI / 180;
    }

    function rad2deg(value) {
        return value * 180 / Math.PI;
    }

    function fixAngle(value) {
        return ((value % 360) + 360) % 360;
    }

    function fixHour(value) {
        if (isNaN(value))
            return NaN;
        return ((value % 24) + 24) % 24;
    }
}
