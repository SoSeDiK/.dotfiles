{ flakeDir, ... }:

{
  environment.shellAliases = {
    # Moving around
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    # QOL
    c = "clear";
    cc = "cd ~ && clear";
    # Replacements
    ls = "eza -lh --group-directories-first --icons=auto";
    lt = "eza --tree --level=2 --long --icons --git";
    # Managing system
    kys = "shutdown now";
    reboot = "systemctl reboot";
    gccleanup = "nh clean all";
    # Helpers
    g = "git";
    gcm = "git commit -m";
    gw = "./gradlew";
    ver = "${flakeDir}/assets/scripts/ver.sh";
    dtheme = "${flakeDir}/assets/_theming/theme.sh";
    theme = "${flakeDir}/assets/_theming/theme.sh";
    trv-1080p = "ffmpeg -i $1 -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy \${1%.*}-1080p.mp4";
    # Updating system
    ## Update flakes and rebuild
    update = "${flakeDir}/assets/scripts/update_system.sh --update";
    ## Rebuild the system
    updates = "${flakeDir}/assets/scripts/update_system.sh";
    ## Commit all changes to .dotfiles
    updatec = "${flakeDir}/assets/scripts/update_commit.sh";
    # Update flake inputs (accepts arguments for specific inputs)
    updatef = "${flakeDir}/assets/scripts/update_flake.sh";
    ## Update system without creating a boot entry
    updatet = "${flakeDir}/assets/scripts/update_system.sh --test";
    ## Make current configuration the one bootable by default
    updateb = "${flakeDir}/assets/scripts/update_system.sh --boot";
    ## Make current configuration the one bootable by default
    updater = "sudo /run/current-system/bin/switch-to-configuration boot";
  };
}
