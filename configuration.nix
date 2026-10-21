# ────────────────────────────────────
#   skt-thinkpad — NixOS Configuration
# ────────────────────────────────────

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/nixos/niri.nix
    ./modules/nixos/gnome.nix
  ];

  # == NixOS Specific
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enables NH (Yet Another Nix CLI Helper https://github.com/nix-community/nh)
  programs.nh = {
    enable = true;
    clean.enable = true; # Enables automatic garbage collection
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/simen/nixos"; # sets NH_OS_FLAKE variable for you
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.simen = import ./home.nix;
    backupFileExtension = "backup";
  };

  nixpkgs.config.allowUnfree = true; # Allow unfree packages...

  # == System & Boot
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        xbootldrMountPoint = "/boot";
        configurationLimit = 10;
      };
      efi = {
        efiSysMountPoint = "/efi";
        canTouchEfiVariables = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest; # Use latest kernel.
  };

  hardware.enableRedistributableFirmware = true;
  zramSwap.enable = true; # In-memory SWAP

  # == Networking
  networking.hostName = "skt-thinkpad";
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;
  services.mullvad-vpn.enable = true;

  services.syncthing = {
    enable = true;
    user = "simen";
    dataDir = "/home/simen";
  };

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true; # Allow non-root capture of packets
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # == System Defaults
  programs.zsh.enable = true; # Default shell for root

  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "no";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "no";
      variant = "nodeadkeys";
      #options = "eurosign:e,caps:escape";
    };
  };
  services.libinput.enable = true; # Enable touchpad support

  users.users.simen = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "wireshark"
    ];
  };

  # == System Packages
  environment.systemPackages = with pkgs; [
    # -- CLI basics
    bat
    git
    tree
    unzip
    wget
    zip

    # -- Editor
    neovim

    # -- Desktop & hardware
    brightnessctl
    xwayland-satellite

    # -- Webcam
    cameractrls
    v4l-utils

    # -- Python
    python3
    uv

    # -- Nix language support
    nixd
    nixfmt
  ];

  # == Virtualisation
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "simen" ];

  # == Power and Session Services
  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    fprintd.enable = true;
  };
  hardware.bluetooth.enable = true;

  # == Fonts
  fonts.packages = with pkgs; [
    # Bitmaps
    nerd-fonts.departure-mono
    cozette
    terminus_font # Fin på 14px tamsyn
    nerd-fonts.mononoki
    nerd-fonts.gohufont
    nerd-fonts.iosevka-term
    tamzen
    google-fonts
  ];

  # DO NOT EVER CHANGE THIS LINE
  system.stateVersion = "26.05"; # Did you read the comment?

}
