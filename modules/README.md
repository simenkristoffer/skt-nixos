# modules/

This is the first modularization of the repo — everything used to live
flat in `configuration.nix`/`home.nix`. The niri+noctalia setup was ported
from plain dotfiles (`~/backup/nixos-migration/02-dotfiles/`) and is large
enough that it would have made the two root files unwieldy, hence this
structure.

## Layout

```
modules/
├── niri.nix                       NixOS-level: niri-flake wiring (overlay + programs.niri)
└── home/
    ├── niri/
    │   ├── default.nix            home-manager: niri config + noctalia.kdl seed
    │   ├── config.kdl             Ported niri config (raw KDL)
    │   └── noctalia-theme-seed.kdl Placeholder for niri's `include "noctalia.kdl"`
    └── noctalia/
        ├── default.nix            home-manager: noctalia config
        └── settings.toml          Ported noctalia settings.toml
```

## How niri and noctalia are wired together

- `modules/niri.nix` sets `programs.niri.enable = true;` via
  [niri-flake](https://github.com/sodiboo/niri-flake)'s NixOS module. Since
  home-manager runs integrated (not standalone), this module
  **automatically** imports `niri.homeModules.config` for all home-manager
  users. `modules/home/niri/default.nix` must therefore **not** import
  `homeModules.niri` itself or set `programs.niri.enable` again — that
  collides with the NixOS module's own declaration. This is documented in
  niri-flake's `docs.md` under "NixOS module", but easy to trip over.
- `modules/home/niri/default.nix` writes `config.kdl` to
  `~/.config/niri/config.kdl` via `xdg.configFile` (a regular Nix store
  symlink), **not** via niri-flake's `programs.niri.config` option. Two
  reasons: (1) the source config uses `blur {}` and `background-effect`
  (niri 26.04+ features) that may not be modeled in the `settings` schema,
  so a raw KDL string is safer than hand-translating to Nix attrs; (2)
  `programs.niri.config` validates the KDL at build time via
  `niri validate`, and that validation fails because `include
  "noctalia.kdl"` (see below) points at a file that deliberately doesn't
  exist in the Nix store/build sandbox. `xdg.configFile` writes the same
  content without triggering that validation.
- `config.kdl` ends with `include "noctalia.kdl"`. That file is
  generated/overwritten by noctalia itself at runtime (color palette →
  niri theme), and must therefore **not** be a Nix store symlink (it would
  become read-only and get clobbered on every `home-manager switch`, and
  would fail niri-flake's build-time validation anyway, as explained
  above). Instead, `default.nix` seeds a placeholder
  (`noctalia-theme-seed.kdl`) via `home.activation`, only if the file
  doesn't already exist.
- `modules/home/noctalia/default.nix` sets
  `programs.noctalia.settings = builtins.fromTOML (builtins.readFile
  ./settings.toml)` — the same raw-passthrough trick, to avoid
  hand-transcribing ~230 lines of TOML into nested Nix attrsets.
- Noctalia is spawned by niri itself (`spawn-at-startup "noctalia"` in
  `config.kdl`). `programs.noctalia.systemd.enable` is **deliberately
  not** set — enabling both would double-launch noctalia and have two
  processes fight over the same IPC socket (`noctalia msg ...`, used by
  the `Mod+Space` bind for launcher toggling).
- The services noctalia's widgets/plugins require (bluetooth,
  power-profiles-daemon, upower, tailscale, syncthing) live in
  `configuration.nix`, not in `modules/niri.nix` — they're not
  niri-specific, just general host services that noctalia happens to
  need. `modules/niri.nix` stays strictly scoped to niri-flake wiring
  (overlay + `programs.niri.enable`/`package`).

## Deviations from the source dotfiles

- The `yuuto/arch-updater` plugin is removed from `[plugins] enabled` in
  `settings.toml` (it depends on pacman/arch-update, which doesn't exist
  on NixOS).
- The stock wezterm window rule (the `default-column-width {}` workaround)
  is dropped from `config.kdl` — unused, no wezterm in the picture.
- The `config_version` line is removed from `settings.toml` (an internal
  marker — noctalia's own docs confirm it's excluded from exported user
  config).
- `[lockscreen_widgets].enabled = false` is kept as in the source — the
  two per-monitor login-box widgets are configured but **not active**.

## Manual follow-ups

1. **The wallpaper file doesn't exist.** `settings.toml` references
   `/home/simen/Pictures/wallhaven-vp2d98.jpg` in 4 places; it wasn't in
   the backup or on this machine. Put the file there, or change the paths.
2. **First login**: explicitly select "niri" in GDM's session picker
   (GNOME stays the default).
3. **`swaylock`/`konsole`**: the binds in `config.kdl` spawn these
   directly. Add them to `environment.systemPackages` if they don't
   already come in transitively, or swap the binds for programs you
   actually have.

## Resolved during implementation

`blur {}`/`background-effect` (niri 26.04+) weren't supported by
`niri-stable` (25.08) — confirmed by a failed build. `modules/niri.nix`
therefore sets `nixpkgs.overlays = [ inputs.niri.overlays.niri ];` and
`programs.niri.package = pkgs.niri-unstable;`. Both parts were necessary:
the overlay alone doesn't make `programs.niri.package` do anything, and
without the overlay `pkgs.niri-unstable` doesn't exist.
