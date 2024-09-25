{ ... }:

let
  gitUsername = "SoSeDiK";
  gitEmail = "mrsosedik@gmail.com";
in
{
  programs.git = {
    enable = true;
    userName = gitUsername;
    userEmail = gitEmail;
    lfs.enable = true;
    diff-so-fancy.enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      http.postBuffer = 1048576000;
    };
  };
}
