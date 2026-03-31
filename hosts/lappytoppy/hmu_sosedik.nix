{
  self,
  pkgs,
  ...
}:

let
  gitUsername = "SoSeDiK";
  gitEmail = "mrsosedik@gmail.com";
in
{
  imports = [
    # ./home-manager/firefox
    ./home-manager/vscode
    ./home-manager/zen

    # Terminal
    "${self}/home/terminal/programs/cava.nix"

    # # Programs
    "${self}/home/programs/mpv"
    # "${self}/home/programs/ags.nix" # Task bar and many other things
    "${self}/home/programs/clipboard.nix"
    "${self}/home/programs/quickshell.nix" # Task bar and many other things

    # Secrets!
    "${self}/secrets/sops-home.nix"

    # Apps
    "${self}/modules/home-manager/apps/spicetify.nix"

    # Gaming
    "${self}/modules/home-manager/gaming/mangohud.nix"

    # Misc
    "${self}/modules/home-manager/misc/xembed-sni-proxy.nix"

    # Services
    "${self}/modules/home-manager/service/dunst.nix"

    # Shell
    # "${self}/modules/home-manager/shell/shell-aliases.nix"
    # "${self}/modules/home-manager/shell/starship.nix"
    # "${self}/modules/home-manager/shell/zsh.nix"

    # # Theming
    "${self}/modules/home-manager/theming/gtk-qt.nix"
    "${self}/modules/home-manager/theming/stylix.nix"
  ];

  # User apps
  home.packages = with pkgs; [
    nix-inspect
    rofi # App/things launcher
    (bottles.override { removeWarningPopup = true; }) # WINE helper
    crosspipe # Audio
    nurl # fetch sha256 for packages

    # Utils
    fsearch # fast search
    # cpu-x # PC Info
    fontforge-gtk

    # Extra browsers
    tor-browser

    # Misc
    pantheon.elementary-iconbrowser # Browsing GTK icons
    pamixer # Volume control
    wl-mirror # App/screen mirroring
  ];

  # programs.kitty.enable = true;

  # Equalizer
  services.easyeffects.enable = true;

  # Setup git
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
    # See https://git-scm.com/docs/git-config
    settings = {
      user = {
        name = gitUsername;
        email = gitEmail;
      };
      credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
      init = {
        # Prevent complaining on init
        defaultBranch = "master";
      };
      column = {
        # Output in columns when possible
        ui = "auto";
      };
      branch = {
        # Sort branches by most recent commit first
        sort = "-committerdate";
      };
      tag = {
        # Sort version numbers as you would expect
        sort = "version:refname";
      };
      diff = {
        # Clearer diffs on moved/edited lines
        algorithm = "histogram";
        # Highlight moved blocks in diffs
        colorMoved = "plain";
        # More intuitive refs in diff output
        mnemonicPrefix = true;
      };
      push = {
        # Automatically set upstream branch on push
        autoSetupRemote = true;
      };
      pull = {
        # Rebase (instead of merge) on pull
        rebase = true;
      };
      commit = {
        # Include diff comment in commit message template
        verbose = true;
      };
      rebase = {
        # Automatically update stacked refs
        updateRefs = true;
      };
      rerere = {
        # Record and reuse conflict resolutions
        enabled = true;
        # Apply stored conflict resolutions automatically
        autoupdate = true;
      };
      merge = {
        # Show extra context when resolving conflicts
        conflictstyle = "zdiff3";
      };
      http = {
        # Fix large file pushes
        postBuffer = 1048576000;
      };

      # Setup signing commits
      commit.gpgsign = true;
      signing.format = "openpgp";
      user.signingkey = "A2263A612AD152CB";
    };
  };
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };

  # Create XDG Dirs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11"; # tldr: Do not change :)
}
