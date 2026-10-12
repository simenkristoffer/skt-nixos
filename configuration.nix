# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

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
  # -- Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.simen = import ./home.nix;
  home-manager.backupFileExtension = "backup";

  # == System & Boot
  boot.loader.systemd-boot = {
    enable = true;
    xbootldrMountPoint = "/boot";
    configurationLimit = 10;
  };

  boot.loader.efi = {
    efiSysMountPoint = "/efi";
    canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest; # Use latest kernel.
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true; # Allow unfree packages...
  zramSwap.enable = true; # In-memory SWAP

  # == System Defaults
  programs.zsh.enable = true;
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "no";
    # useXkbConfig = true; # use xkb.options in tty.
  };

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

  programs.wireshark.enable = true;
  programs.wireshark.dumpcap.enable = true; # Allow non-root capture of packets
  hardware.bluetooth.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkb.layout = "no";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simen = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "wireshark"
    ];
  };

  # Enable VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "simen" ];

  # List services that you want to enable:

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.fprintd.enable = true;

  # == Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.departure-mono
  ];

  # DO NOT EVER CHANGE THIS LINE
  system.stateVersion = "26.05"; # Did you read the comment?

}
