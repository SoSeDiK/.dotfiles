{ inputs, inputs', pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    grim                                        # Screenshots tool
    slurp                                       # Selecting region
    wayfreeze                                   # Screen freezing
    hyprpicker                                  # Color picker
    inputs'.hyprland-contrib.packages.grimblast # Fancy wrapper around grim
    inputs'.shadower.packages.shadower          # Adding nice shadow to images
    satty                                       # Simple editor
    tesseract                                   # OCR
  ];

  nixpkgs.overlays = [
    inputs.grim-hyprland.overlays.default
  ];
}
