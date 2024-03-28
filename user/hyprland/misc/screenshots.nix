{ inputs, config, pkgs, ... }:

{
  home.packages = with pkgs; [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast # Screenshots tool
    inputs.shadower.packages.${pkgs.system}.shadower # Adding nice shadow to images
    satty # Simple editor
    tesseract # OCR
  ];
}
