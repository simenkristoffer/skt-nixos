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

  # GTK Transparency: sidebar + titlebar go transparent (for niri's blur to
  # show through), content pane stays opaque for readability. Targets
  # libadwaita's AdwOverlaySplitView class names, so it applies to any app
  # using that widget (Nautilus, Settings, ...), not just Nautilus. Lives
  # here (not home.nix) because it only looks right paired with the blur
  # window-rule in config.kdl for the same apps.
  # Source: https://github.com/taiwbi/hypaurora/blob/main/gtk-4.0/tweaks/sidebar.css
  # Note: no `!important` — GTK4's CSS engine doesn't support it (unlike
  # GTK3) and silently drops the whole declaration if present. User CSS
  # already loads after the theme's, so it wins the cascade without it.
  home.file.".config/gtk-4.0/gtk.css".text = ''
    window {
      background: alpha(@window_bg_color, 0.8);
    }

    overlay-split-view revealer.raised.top-bar {
      background: alpha(@window_bg_color, 0);
      box-shadow: none;
    }

    overlay-split-view headerbar.titlebar {
      background: transparent;
      border: none;
      box-shadow: none;
    }

    .sidebar-pane,
    .sidebar,
    .navigation-sidebar {
      background: transparent;
    }

    .content-pane {
      background: @view_bg_color;
    }
  '';
}
