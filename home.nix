# ────────────────────────────────────
#   simen@skt-thinkpad — Home Manager
# ────────────────────────────────────

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./modules/home/desktop/niri
    ./modules/home/desktop/noctalia
    ./modules/home/neovim
  ];

  # == Home Manager Specific
  programs.home-manager.enable = true;

  home.username = "simen";
  home.homeDirectory = "/home/simen";

  # TODO: xdg.userDirs

  # == Packages
  home.packages = with pkgs; [
    # -- 3D Printing
    orca-slicer

    # -- Browser
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

    # -- Productivity
    foliate
    libreoffice
    obsidian
    todoist
    zotero

    # -- Communication
    aerc
    discord
    zoom-us

    # -- Media
    catt
    spotify

    # -- Development
    nodejs_22
    vscode

    # -- Databases
    dbeaver-bin
    harlequin
    mysql-workbench

    # -- Networking & Remote
    rustdesk
    wireshark

  ];

  # == Shell
  programs.zsh = {
    enable = true;
    enableCompletion = false; # Makes Antidote load faster
    antidote = {
      enable = true;
      plugins = [
        "mattmc3/zfunctions"
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "zsh-users/zsh-history-substring-search"
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  # == Terminal
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [ "~/.config/alacritty/themes/noctalia.toml" ];
      };
      cursor = {
        style = {
          shape = "Underline";
          blinking = "Always";
        };
      };
      window = {
        opacity = 0.78;
        blur = false;
        padding = {
          x = 7;
          y = 7;
        };
      };
      font = {
        normal = {
          family = "Adwaita Mono";
          style = "Regular";
        };
        size = 14;
      };
    };
  };

  # == Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Simen Kristoffer";
        email = "post@simenkristoffer.no";
      };
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  # == Helix
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
      };
      theme = "base16_transparent";
    };
  };


  # == Theming
  home.pointerCursor = {
    # The cursor is super tiny if this is not set.
    gtk.enable = true;
    x11.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 16;
  };

  # DO NOT EVER CHANGE THIS LINE
  home.stateVersion = "26.05"; # Did you read the comment?
}
