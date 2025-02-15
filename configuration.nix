# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking 
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  systemd.sleep.extraConfig = ''
    SuspendMode=suspend
    HibernateMode=shutdown
  '';

  # Power management and GPU settings
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance"; # Or "ondemand" if you prefer battery life
    resumeCommands = "journalctl -b -1 -k > /var/log/suspend.log";
  };


# AMD GPU specific settings
  # hardware.grahpics = {
  #   enable = true;
  #   # driSupport = true;
  #   driSupport32Bit = true;
  #   extraPackages = with pkgs; [
  #     amdvlk
  #     # rocm-opencl-icd
  #     # rocm-opencl-runtime
  #   ];
  # };

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ar_EG.UTF-8";
    LC_IDENTIFICATION = "ar_EG.UTF-8";
    LC_MEASUREMENT = "ar_EG.UTF-8";
    LC_MONETARY = "ar_EG.UTF-8";
    LC_NAME = "ar_EG.UTF-8";
    LC_NUMERIC = "ar_EG.UTF-8";
    LC_PAPER = "ar_EG.UTF-8";
    LC_TELEPHONE = "ar_EG.UTF-8";
    LC_TIME = "ar_EG.UTF-8";
  };
  # i18n.inputMethod.enabled = "ibus";
  # xdg.portal.enable = true;
  services.flatpak.enable = true;


services.xserver = {
  # Enable the X11 windowing system.
  enable = true;


  # Enable AMDGPU driver and add custom modes
  videoDrivers = [ "amdgpu" ];
  
  # Add custom monitor configuration
  config = ''
    Section "Monitor"
      Identifier "VGA-1" # Replace with your monitor's identifier from xrandr
      Option "ModeValidation" "AllowNonEdidModes"
      Modeline "1366x768_60.00"   85.25  1366 1436 1579 1792  768 771 781 798 -hsync +vsync
      Option "PreferredMode" "1366x768_60.00"
    EndSection

    Section "Device"
      Identifier "AMD"
      Driver "amdgpu"
      Option "ModeDebug" "true"
    EndSection
  '';

  monitorSection = ''
  Option "CustomEDID" "VGA-1:/path/to/edid.bin"
'';
  # Apply xrandr commands at display start
  displayManager = {
    
    gdm = {
      enable = true;       # Explicitly enable GDM
      wayland = false;     # Force Xorg session
    };

    setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --newmode "1366x768_60.00" 85.25 1366 1436 1579 1792 768 771 781 798 -hsync +vsync
        ${pkgs.xorg.xrandr}/bin/xrandr --addmode VGA-1 "1366x768_60.00"
        ${pkgs.xorg.xrandr}/bin/xrandr --output VGA-1 --mode "1366x768_60.00"
      '';

  };

  desktopManager.gnome.enable = true;
};


    xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };


# Required for auto-login with any display manager
services.displayManager = {
  autoLogin = {
    enable = true;
    user = "fahd";
  };
  defaultSession = "gnome";  # Explicitly set GNOME session
};

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

## second Monitor does not report its supported resolutions properly. Force EDID data:
# hardware.opengl.extraPackages = with pkgs; [ vaapiVdpau ];
#services.xserver.monitorSection = ''
 # Section "Monitor"
  #  Identifier "VGA-1"
   # Option "CustomEDID" "VGA-1:/path/to/edid.bin"  # Get EDID from Windows/another OS
  #EndSection
# '';

  hardware = {
    # Enable non-free firmware (important for many wireless cards)
    enableRedistributableFirmware = true;


    firmware = with pkgs; [
      firmwareLinuxNonfree # Includes AMD-specific firmware
      linux-firmware  # Contains firmware for many wireless cards
      firmwareLinuxNonfree  # Additional proprietary firmware

    ];
  };

  services.logind = {
    lidSwitch = "suspend";
    extraConfig = ''
      HandleLidSwitch=suspend
      HandleLidSwitchExternalPower=suspend
      IdleAction=suspend
      IdleActionSec=30min
    '';
  };

  # Better ACPI handling
  services.acpid.enable = true;

  # Improve suspend behavior
  boot = {
  # bootloader
  # Keep more generations for safety
  loader.systemd-boot.configurationLimit = 10;
  loader.systemd-boot.enable =   true;
  loader.efi.canTouchEfiVariables = true;

  #   kernelParams = [
  #   amdgpu.dc=1           # Enable Display Core (modern power management)
  #   amdgpu.dpm=1          # Enable Dynamic Power Management
  #   acpi_osi=!Windows 2020 # Improve ACPI compatibility for suspend
  # ];
  
};

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;    # ALSA integration
    pulse.enable = true;   # PulseAudio compatibility
    jack.enable = true;    # JACK support (for pro-audio)
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1022", ATTR{device}=="0x1483", ATTR{power/wakeup}="disabled"
  '';

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fahd = {
    isNormalUser = true;
    description = "fahd";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # If you don't already have swap, add this
  swapDevices = [
    { device = "/var/lib/swapfile";
      size = 8192; # Size in MB (adjust based on your RAM)
    }
  ];

  # # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "fahd";
  # services.displayManager.autoLogin.user = "fahd";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
 nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "vscode"
             "jetbrains.clion"
           ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # apps
    discord 
    vscode
    # jetbrains.clion
    obsidian
    postman
    # appimage-run 
    # arandr

  # cli
    git
    gh
  
  # compilers / languages
    rustup
    rustc
    rustfmt       # Code formatter
    clippy        # Linter
    rust-analyzer # LSP server for IDEs
    cargo

    cmake
    gcc

    nodejs_22
    # bun
    wasm-pack

    openssl
    openssl.dev
  
    # LLVM tools including lld linker
    llvmPackages.lld
    libffi
    
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

  # i hate dealing with this
    ntfs3g
    # gnome-tweaks
    toybox
    lshw

  # testing with this. might delete them
    iw              # WiFi debugging tools
    wirelesstools   # Additional wireless utilities
    ethtool         # Network driver and hardware control

  wget
  ];

# environment.variables = {
#   LD_LIBRARY_PATH = "/path/to/nix/store/path-containing-libmetacall/lib";
#   PATH = [ "/path/to/nix/store/path-containing-libmetacall/bin" ];
# };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [

    # Add any missing dynamic libraries for unpackaged programs

    # here, NOT in environment.systemPackages

    gtk3

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
