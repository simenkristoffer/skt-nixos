{ config, ... }:
{
  # No `imports` here: niri-flake's NixOS module (programs.niri.enable in
  # modules/niri.nix) already auto-imports homeModules.config for all
  # home-manager users when home-manager runs integrated into NixOS. A
  # manual import of homeModules.niri would collide with that.

  # Not programs.niri.config: that option validates the KDL at build time
  # via `niri validate`, and the validator can't follow
  # `include "noctalia.kdl"` since that file is deliberately not a Nix
  # store file (see below) and so doesn't exist in the build sandbox.
  # xdg.configFile writes the same content without triggering validation.
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  # noctalia overwrites this file itself when it generates a theme. It
  # must exist (valid KDL) BEFORE niri's `include "noctalia.kdl"` line is
  # evaluated at startup, and must remain writable by noctalia afterwards
  # — hence not xdg.configFile for THIS file (would become a read-only
  # Nix store symlink).
  home.activation.seedNoctaliaKdlTheme = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    target="${config.home.homeDirectory}/.config/niri/noctalia.kdl"
    if [ ! -e "$target" ]; then
      install -D -m644 ${./noctalia-theme-seed.kdl} "$target"
    fi
  '';
}
