{ config, ... }:
{
  # Not imported: niri-flake auto-imports homeModules.config via modules/niri.nix.

  # Raw KDL, not programs.niri.config, to skip build-time validation (fails on `include "noctalia.kdl"`).
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  # Seeds noctalia's theme file once; noctalia owns and rewrites it afterwards.
  home.activation.seedNoctaliaKdlTheme = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    target="${config.home.homeDirectory}/.config/niri/noctalia.kdl"
    if [ ! -e "$target" ]; then
      install -D -m644 ${./noctalia-theme-seed.kdl} "$target"
    fi
  '';

  # Makes Gnome apps with sidebars transparent
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
