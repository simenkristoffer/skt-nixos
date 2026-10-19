{ inputs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia.enable = true;
  programs.noctalia.settings = builtins.fromTOML (builtins.readFile ./settings.toml);

  # Don't enable programs.noctalia.systemd.enable: config.kdl already
  # spawns noctalia via `spawn-at-startup`. Enabling the systemd service
  # too would double-launch noctalia and have two processes fight over
  # the same IPC socket (`noctalia msg ...`, used by the Mod+Space bind).
}
