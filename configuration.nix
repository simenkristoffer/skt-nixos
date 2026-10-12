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
    ./modules/nixos/niri/default.nix
    ./modules/nixos/gnome/default.nix
  ];

  # == NixOS Specific
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.simen = import ./home.nix;
    backupFileExtension = "backup";
  };

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
  nixpkgs.config.allowUnfree = true; # Allow unfree packages...
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
    # Essential
    brightnessctl
    xwayland-satellite
    wget
    neovim
    git
    zip
    unzip
    # Nix language support
    nixfmt
    nixd
  ];

  # == Virtualisation
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "simen" ];

  # == Power and Session Services
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.fprintd.enable = true;
  hardware.bluetooth.enable = true;

  # == Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.departure-mono
  ];

  # DO NOT EVER CHANGE THIS LINE
  system.stateVersion = "26.05"; # Did you read the comment?

}
