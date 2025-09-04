{ flakeDir, ... }:

{
  home.shellAliases = {
    # Moving around
    ".." = "cd ..";
    "..." = "cd ../..";
    c = "clear";
    cc = "cd ~ && clear";
    # Helpers
    gw = "./gradlew";
    ver = "${flakeDir}/assets/scripts/ver.sh";
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
    updatet = "${flakeDir}/assets/scripts/update_test.sh";
    ## Make current configuration the one bootable by default
    updateb = "sudo /run/current-system/bin/switch-to-configuration boot";
    # Managing system
    kys = "shutdown now";
    reboot = "systemctl reboot";
    gccleanup = "nh clean all";
  };
}
