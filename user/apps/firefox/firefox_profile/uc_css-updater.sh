#!/usr/bin/env bash
# Script removes old US.CSS files, and copies new ones instead
# US.CSS source: https://github.com/aminomancer/uc.css.js
outputDir=~/.dotfiles/user/apps/firefox/firefox_profile/chrome

# In test mode, there's no cleanup
testMode=true

preserveScripts=()

# Any extra scripts wanted from JS folder
# Note: extra scripts have to be removed manually upon uninstalaling!
extraScripts=(
    extensionOptionsPanel.uc.js               # Extension Options Panel
    verticalTabsPane.uc.js                    # Vertical Tabs Pane
    aboutUserChrome.sys.mjs                   # about:userchrome
    aboutCfg.uc.js                            # about:cfg
    appMenuAboutConfigButton.uc.js            # App Menu about:config Button
    appMenuMods.uc.js                         # App Menu Mods
    allTabsMenuExpansionPack.uc.js            # All Tabs Menu Expansion Pack
    atoolboxButton.uc.js                      # Toolbox Button
    bookmarksPopupShadowRoot.uc.js            # Bookmarks Popup Mods
    clearDownloadsButton.uc.js                # Clear Downloads Panel Button
    contextMenuMods.uc.js                     # Context Menu Mods
    copyCurrentUrlHotkey.uc.js                # Copy Current URL Hotkey; Ctrl+Alt+C
    debugExtensionInToolbarContextMenu.uc.js  # Debug Extension in Toolbar Context Menu
    eyedropperButton.uc.js                    # Eyedropper Button
    invertPDFButton.sys.mjs                   # Invert PDF Button
    fluentRevealTabs.uc.js                    # Fluent Reveal Tabs
    fluentRevealNavbar.uc.js                  # Fluent Reveal Navbar Buttons
    ## enterInUrlbarToRefresh.uc.js              # Hit Enter in Urlbar to Refresh
    letCtrlWClosePinnedTabs.uc.js             # Let Ctrl+W Close Pinned Tabs
    openBookmarksHistoryEtcInNewTabs.uc.js    # Open Bookmarks, History, etc. in New Tabs
    ## openBookmarkInContainerTab.uc.js          # Open Bookmark in Container Tab (context menu) | Makes tab context menu black
    openLinkInUnloadedTab.uc.js               # Open Link in Unloaded Tab (context menu item)
    privateTabs.uc.js                         # Private Tabs
    screenshotPageActionButton.uc.js          # Screenshot Page Action Button
    searchSelectionShortcut.sys.mjs             # Search Selection Keyboard Shortcut
    tabContextMenuNavigation.uc.js            # Tab Context Menu Navigation
    tabThumbnailTooltip.uc.js                 # Tab Thumbnail Tooltip
    ## tabTooltipNavButtons.uc.js                # Tab Tooltip Navigation Buttons
    toggleMenubarHotkey.uc.js                 # Toggle Menubar Hotkey
    trackingProtectionMiddleClickToggle.uc.js # Tracking Protection Middle Click Toggle
    animateContextMenus.uc.js                 # Animate Context Menus
    recentlyClosedTabsContextMenu.uc.js       # Undo Recently Closed Tabs in Tab Context Menu
    unreadTabMods.uc.js                       # Unread Tab Mods
    urlbarContainerColor.uc.js                # Urlbar Container Color Indicator
    urlbarMouseWheelScroll.uc.js              # Scroll Urlbar with Mousewheel
    urlbarViewScrollSelect.uc.js              # Scroll Urlbar Results with Mousewheel
    pinTabHotkey.uc.js                        # Pin Tab Hotkey
    windowDragHotkey.uc.js                    # Window Drag Hotkey; Alt + Shift + LMB
    customHintProvider.uc.js                  # Custom Hint Provider
    miscMods.uc.js                            # Misc. Mods
)
# Skipped:
# Bookmarks Menu & Button Shortcuts
# Browser Chrome Bookmark Keywords
# Fullscreen Hotkey
# Private Window Homepage
# Update Notification Slayer
# Concise Update Banner Labels
# Backspace Panel Navigation

# Download latest uc.css.js
parentOutputDir=$(readlink -f "$outputDir"/..)
pushd $parentOutputDir
if [ ! -d "uc.css.js-master" ]; then
    curl -LO https://github.com/aminomancer/uc.css.js/archive/refs/heads/master.zip
    unzip master.zip
fi
inputDir=./uc.css.js-master

# Check if source folder exists
if [ ! -d "$inputDir" ]; then
    echo "Error: Directory '$inputDir' does not exist. Exiting."
    exit 1
fi

# Just in case
mkdir -p $outputDir
# Remove all old files and directories
rm -rf "$outputDir"/*

# Copy required folders
files=("CSS" "resources" "utils")
for file in "${files[@]}"; do
    rm -rf "${outputDir}/${file}"
    cp -r "${inputDir}/${file}" "${outputDir}"
done

# Copy .css files
cp "$inputDir"/*.css "$outputDir"

# Symlink to chrome extras
ln -sf $parentOutputDir/chrome_extras $outputDir/chrome_extras
ln -sf $parentOutputDir/chrome_extras $outputDir/resources/in-content/chrome_extras

# Write custom custom-chrome.css
echo -e "@import url(chrome_extras/custom-chrome.css);\n" | cat - "$outputDir/custom-chrome.css" > temp && mv temp "$outputDir/custom-chrome.css"
# Write custom custom-content.css
echo -e "@import url(chrome_extras/custom-content.css);\n" | cat - "$outputDir/resources/in-content/custom-content.css" > temp && mv temp "$outputDir/resources/in-content/custom-content.css"

# # Commenting out some of the css variables
# replacements=(
#     "--lwt-"
#     "--toolbar-color"
#     "--toolbar-bgcolor"
# )
# for pattern in "${replacements[@]}"; do
#     sed -i "s/\(.*${pattern}.*;\)/\/\* \1 \*\//g" "$outputDir/uc-variables.css"
# done


# Copy required JS files
files=(
    extensionStylesheetLoader.sys.mjs                     # Extension Stylesheet Loader
    findbarMods.uc.js                                   # Findbar Mods
    fixTitlebarTooltips.uc.js                           # Fix Titlebar Button Tooltips
    floatingSidebarResizer.uc.js                        # Floating Sidebar Resizer
    autoHideNavbarSupport.uc.js                         # Auto-hide Navbar Support
    hideTrackingProtectionIconOnCustomNewTabPage.uc.js  # Hide Tracking Protection Icon on Custom New Tab Page
    # navbarToolbarButtonSlider.uc.js                     # Navbar Toolbar Button Slider
    oneClickOneOffSearchButtons.uc.js                   # One-click One-off Search Buttons
    removeSearchEngineAliasFormatting.uc.js             # Remove Search Engine Alias Formatting
    restoreTabSoundButton.uc.js                         # Restore pre-Proton Tab Sound Button
    # Restore pre-Proton Arrowpanels <- Handled in CSS
    restorePreProtonLibraryButton.uc.js                 # Restore pre-Proton Library Button
    restorePreProtonStarButton.uc.js                    # Restore pre-Proton Star Button
    scrollingOneOffs.uc.js                              # Scrolling Search One-offs
    searchModeIndicatorIcons.uc.js                      # Search Mode Indicator Icons
    showSelectedSidebarInSwitcherPanel.uc.js            # Show Selected Sidebar in Switcher Panel
    tabAnimation.uc.js                                  # Tab Animation Workaround
    tabLoadingSpinner.uc.js                             # Tab Loading Spinner Animation
    tooltipShadowSupport.uc.js                          # Tooltip Shadow Support
    tooltipStyler.uc.js                                 # Tooltip Styler
    urlbarMods.uc.js                                    # Urlbar Mods
    urlbarNotificationIconsOpenStatus.uc.js             # Add [open] Status to Urlbar Notification Icons
    autocompletePopupStyler.uc.js                       # Autocomplete Popup Styler
    userChromeAgentAuthorSheetLoader.uc.js              # Agent/Author Sheet Loader
    userChromeDevtoolsSheetLoader.uc.js                 # Browser Toolbox Stylesheet Loader # TODO currently is not integrated
    osDetector.uc.js                                    # OS Detector
)
mkdir -p $outputDir/JS
for file in "${files[@]}"; do
    cp "${inputDir}/JS/${file}" "${outputDir}/JS"
done

# Copy extra scripts
files=("${extraScripts[@]}")
for file in "${files[@]}"; do
    cp "${inputDir}/JS/${file}" "${outputDir}/JS"
done

# Remove leftover files
if [ "$testMode" = false ]; then
    rm -f master.zip
    rm -rf uc.css.js-master
fi

popd
