{ ... }:

{
  # Starship Prompt
  programs.starship.enable = true;
  # Better cd command
  programs.zoxide.enable = true;

  xdg.configFile."starship.toml".source = ./files/starship.toml;
}
