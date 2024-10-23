{ inputs', pkgs, ... }:

{
  home.packages = with pkgs; [
    inputs'.hyprland-contrib.packages.grimblast # Screenshots tool
    inputs'.shadower.packages.shadower # Adding nice shadow to images
    satty # Simple editor
    tesseract # OCR
  ];
}
