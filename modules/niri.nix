{ inputs, pkgs, ... }:
{
  imports = [ inputs.niri.nixosModules.niri ];

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.niri.enable = true;
  # niri-stable (25.08) doesn't understand `blur {}`/`background-effect`
  # (niri 26.04+ features used in modules/home/niri/config.kdl) —
  # confirmed by a failed build.
  programs.niri.package = pkgs.niri-unstable;
}
