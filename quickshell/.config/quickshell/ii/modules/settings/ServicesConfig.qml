import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    ContentSection {
        icon: "neurology"
        title: Translation.tr("AI")

        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("System prompt")
            text: Config.options.ai.systemPrompt
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Qt.callLater(() => {
                    Config.options.ai.systemPrompt = text;
                });
            }
        }
    }

    ContentSection {
        icon: "cell_tower"
        title: Translation.tr("Networking")

        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("User agent (for services that require it)")
            text: Config.options.networking.userAgent
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Config.options.networking.userAgent = text;
            }
        }
    }

    ContentSection {
        icon: "memory"
        title: Translation.tr("Resources")

        ConfigSpinBox {
            icon: "av_timer"
            text: Translation.tr("Polling interval (ms)")
            value: Config.options.resources.updateInterval
            from: 100
            to: 10000
            stepSize: 100
            onValueChanged: {
                Config.options.resources.updateInterval = value;
            }
        }
    }

    ContentSection {
        icon: "mosque"
        title: Translation.tr("Prayer times")

        MaterialTextField {
            Layout.fillWidth: true
            placeholderText: Translation.tr("Location name")
            text: Config.options.sidebar.prayer.locationName
            onTextChanged: {
                Config.options.sidebar.prayer.locationName = text;
                PrayerTimes.refreshPrayers();
            }
        }

        ConfigSwitch {
            buttonIcon: "my_location"
            text: Translation.tr("Use manual coordinates")
            checked: Config.options.sidebar.prayer.useManualCoordinates
            onCheckedChanged: {
                Config.options.sidebar.prayer.useManualCoordinates = checked;
                PrayerTimes.refreshPrayers();
            }
        }

        ConfigSwitch {
            buttonIcon: "location_searching"
            text: Translation.tr("Use weather location")
            checked: Config.options.sidebar.prayer.useWeatherLocation
            onCheckedChanged: {
                Config.options.sidebar.prayer.useWeatherLocation = checked;
                PrayerTimes.refreshPrayers();
            }
            StyledToolTip {
                text: Translation.tr("Requires a valid location from the weather service")
            }
        }

        ContentSubsection {
            title: Translation.tr("Coordinates")

            ConfigRow {
                uniform: true
                MaterialTextField {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Latitude (-90 to 90)")
                    text: Number(Config.options.sidebar.prayer.latitude).toFixed(4)
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    onEditingFinished: {
                        const parsed = parseFloat(text);
                        if (!isNaN(parsed) && parsed >= -90 && parsed <= 90) {
                            Config.options.sidebar.prayer.latitude = parsed;
                            PrayerTimes.refreshPrayers();
                        }
                        text = Number(Config.options.sidebar.prayer.latitude).toFixed(4);
                    }
                }
                MaterialTextField {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Longitude (-180 to 180)")
                    text: Number(Config.options.sidebar.prayer.longitude).toFixed(4)
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    onEditingFinished: {
                        const parsed = parseFloat(text);
                        if (!isNaN(parsed) && parsed >= -180 && parsed <= 180) {
                            Config.options.sidebar.prayer.longitude = parsed;
                            PrayerTimes.refreshPrayers();
                        }
                        text = Number(Config.options.sidebar.prayer.longitude).toFixed(4);
                    }
                }
            }
        }

        ContentSubsection {
            title: Translation.tr("Calculation")

            ConfigRow {
                uniform: true
                ConfigSpinBox {
                    icon: "brightness_5"
                    text: Translation.tr("Fajr angle")
                    value: Config.options.sidebar.prayer.fajrAngle
                    from: 0
                    to: 30
                    stepSize: 1
                    onValueChanged: {
                        Config.options.sidebar.prayer.fajrAngle = value;
                        PrayerTimes.refreshPrayers();
                    }
                }
                ConfigSpinBox {
                    icon: "brightness_2"
                    text: Translation.tr("Isha angle")
                    value: Config.options.sidebar.prayer.ishaAngle
                    from: 0
                    to: 30
                    stepSize: 1
                    onValueChanged: {
                        Config.options.sidebar.prayer.ishaAngle = value;
                        PrayerTimes.refreshPrayers();
                    }
                }
            }

            ConfigSpinBox {
                icon: "shadow"
                text: Translation.tr("Asr school (shadow factor)")
                value: Config.options.sidebar.prayer.asrFactor
                from: 1
                to: 2
                stepSize: 1
                onValueChanged: {
                    Config.options.sidebar.prayer.asrFactor = value;
                    PrayerTimes.refreshPrayers();
                }
                StyledToolTip {
                    text: Translation.tr("1 for standard (Shafi'i, Maliki, Hanbali), 2 for Hanafi")
                }
            }
        }
    }

    ContentSection {
        icon: "search"
        title: Translation.tr("Search")

        ConfigSwitch {
            text: Translation.tr("Use Levenshtein distance-based algorithm instead of fuzzy")
            checked: Config.options.search.sloppy
            onCheckedChanged: {
                Config.options.search.sloppy = checked;
            }
            StyledToolTip {
                text: Translation.tr("Could be better if you make a ton of typos,\nbut results can be weird and might not work with acronyms\n(e.g. \"GIMP\" might not give you the paint program)")
            }
        }

        ContentSubsection {
            title: Translation.tr("Prefixes")
            ConfigRow {
                uniform: true
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Action")
                    text: Config.options.search.prefix.action
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.action = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Clipboard")
                    text: Config.options.search.prefix.clipboard
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.clipboard = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Emojis")
                    text: Config.options.search.prefix.emojis
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.emojis = text;
                    }
                }
            }

            ConfigRow {
                uniform: true
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Math")
                    text: Config.options.search.prefix.math
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.math = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Shell command")
                    text: Config.options.search.prefix.shellCommand
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.shellCommand = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Web search")
                    text: Config.options.search.prefix.webSearch
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.webSearch = text;
                    }
                }
            }
        }
        ContentSubsection {
            title: Translation.tr("Web search")
            MaterialTextArea {
                Layout.fillWidth: true
                placeholderText: Translation.tr("Base URL")
                text: Config.options.search.engineBaseUrl
                wrapMode: TextEdit.Wrap
                onTextChanged: {
                    Config.options.search.engineBaseUrl = text;
                }
            }
        }
    }
}
