{ inputs', pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprpicker # Screen freezing, color picker
    inputs'.hyprland-contrib.packages.grimblast # Screenshots tool
    inputs'.shadower.packages.shadower # Adding nice shadow to images
    satty # Simple editor
    tesseract # OCR
  ];
}
