{ inputs, pkgs, ... }:

let
  # Better Spofify
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;

    enabledCustomApps = with spicePkgs.apps; [
      newReleases
      lyricsPlus
      marketplace # Can't install from it, but it's there for browsing
      historyInSidebar
    ];

    enabledSnippets = with spicePkgs.snippets; [
      pointer
      thickerBars
      smoothProgressBar
      removeTopSpacing
    ];

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      powerBar
      fullAppDisplayMod
      popupLyrics
      shuffle # shuffle+ (special characters are sanitized out of extension names)
      seekSong
      fullAlbumDate
      copyToClipboard
      hidePodcasts
      history
      betterGenres
      listPlaylistsWithSong
      playNext
    ];
  };
}
