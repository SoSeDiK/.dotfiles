{ pkgs, ... }:

let
  browserOfChoice = pkgs.brave;
in {
  environment.systemPackages = [
    browserOfChoice
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden Password Manager
      "fkagelmloambgokoeokbpihmgpkbgbfm" # Indie Wiki Buddy
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube
      "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
      "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey
      "blipmdconlkpinefehnmjammfjpmpbjk" # Lighthouse
    ];
    extraOpts = {
      "PasswordManagerEnabled" = false;
      "BraveRewardsDisabled" = true;
      "BraveWalletDisabled" = false;
    };
  };
}
