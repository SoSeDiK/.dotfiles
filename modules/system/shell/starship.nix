{
  lib,
  homeUsers,
  flakeDir,
  ...
}:

{
  # Starship Prompt
  programs.starship.enable = false;

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/starship.toml".source = "${flakeDir}/assets/programs/starship.toml";
    };
  });
}
