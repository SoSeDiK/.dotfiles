#!/usr/bin/env bash
# Script removes old US.CSS files, and copies new ones instead
# US.CSS source: https://github.com/aminomancer/uc.css.js
# Depends on: https://github.com/MrOtherGuy/fx-autoconfig
outputDir=~/.dotfiles/assets/firefox/chrome

# In test mode, there's no cleanup
testMode=true

# Any extra scripts wanted from JS folder
extraScripts=(
    # extensionOptionsPanel.uc.js               # Extension Options Panel
    # # verticalTabsPane.uc.js                    # Vertical Tabs Pane | Skipped, obsolete and breaks often
    # aboutUserChrome.sys.mjs                   # about:userchrome
    # aboutCfg.sys.mjs                          # about:cfg
    # appMenuAboutConfigButton.uc.js            # App Menu about:config Button
    # appMenuMods.uc.js                         # App Menu Mods
    # allTabsMenuExpansionPack.uc.js            # All Tabs Menu Expansion Pack
    # atoolboxButton.uc.js                      # Toolbox Button
    # bookmarksPopupShadowRoot.uc.js            # Bookmarks Popup Mods
    # # bookmarksMenuAndButtonShortcuts.uc.js     # Bookmarks Menu & Button Shortcuts | Skipped
    # ## browserChromeBookmarkKeywords.uc.js       # Browser Chrome Bookmark Keywords | Skipped, broken
    # clearDownloadsButton.uc.js                # Clear Downloads Panel Button
    # # contextMenuMods.uc.js                     # Context Menu Mods | Skipped | Makes search not only with Google
    # copyCurrentUrlHotkey.uc.js                # Copy Current URL Hotkey; Ctrl+Alt+C
    # debugExtensionInToolbarContextMenu.uc.js  # Debug Extension in Toolbar Context Menu
    # eyedropperButton.uc.js                    # Eyedropper Button
    # invertPDFButton.sys.mjs                   # Invert PDF Button
    # fluentRevealTabs.uc.js                    # Fluent Reveal Tabs
    # fluentRevealNavbar.uc.js                  # Fluent Reveal Navbar Buttons
    # # fullscreenHotkey.uc.js                    # Fullscreen Hotkey | Skipped
    # ## enterInUrlbarToRefresh.uc.js              # Hit Enter in Urlbar to Refresh | Skipped
    # letCtrlWClosePinnedTabs.uc.js             # Let Ctrl+W Close Pinned Tabs
    # openBookmarksHistoryEtcInNewTabs.uc.js    # Open Bookmarks, History, etc. in New Tabs
    # ## openBookmarkInContainerTab.uc.js          # Open Bookmark in Container Tab (context menu) | Makes tab context menu black
    # openLinkInUnloadedTab.uc.js               # Open Link in Unloaded Tab (context menu item)
    # privateTabs.uc.js                         # Private Tabs
    # # privateWindowHomepage.uc.js               # Private Window Homepage | Skipped
    # screenshotPageActionButton.uc.js          # Screenshot Page Action Button
    # searchSelectionShortcut.sys.mjs             # Search Selection Keyboard Shortcut
    # tabContextMenuNavigation.uc.js            # Tab Context Menu Navigation
    # tabThumbnailTooltip.uc.js                 # Tab Thumbnail Tooltip
    # ## tabTooltipNavButtons.uc.js                # Tab Tooltip Navigation Buttons
    # toggleMenubarHotkey.uc.js                 # Toggle Menubar Hotkey
    # trackingProtectionMiddleClickToggle.uc.js # Tracking Protection Middle Click Toggle
    # animateContextMenus.uc.js                 # Animate Context Menus
    # recentlyClosedTabsContextMenu.uc.js       # Undo Recently Closed Tabs in Tab Context Menu
    # unreadTabMods.uc.js                       # Unread Tab Mods
    # # updateNotificationSlayer.uc.js            # Update Notification Slayer | Skipped, handling updates differently
    # # updateBannerLabels.uc.js                  # Concise Update Banner Labels | Skipped, handling updates differently
    # urlbarContainerColor.uc.js                # Urlbar Container Color Indicator
    # urlbarMouseWheelScroll.uc.js              # Scroll Urlbar with Mousewheel
    # urlbarViewScrollSelect.uc.js              # Scroll Urlbar Results with Mousewheel
    # # backspacePanelNav.uc.js                   # Backspace Panel Navigation | Skipped
    # pinTabHotkey.uc.js                        # Pin Tab Hotkey
    # windowDragHotkey.uc.js                    # Window Drag Hotkey; Alt + Shift + LMB
    # customHintProvider.uc.js                  # Custom Hint Provider
    # miscMods.uc.js                            # Misc. Mods
)

# Download latest uc.css.js
parentOutputDir=$(readlink -f "$outputDir"/..)
pushd $parentOutputDir
if [ ! -d "uc.css.js-master" ]; then
    curl -o uc.css.js-master.zip -LO https://github.com/aminomancer/uc.css.js/archive/refs/heads/master.zip
    unzip uc.css.js-master.zip
fi
if [ ! -d "fx-autoconfig-master" ]; then
    curl -o fx-autoconfig-master.zip -LO https://github.com/MrOtherGuy/fx-autoconfig/archive/refs/heads/master.zip
    unzip fx-autoconfig-master.zip
fi
inputDir=./uc.css.js-master
utilsDir=./fx-autoconfig-master

# Check if source folder exists
if [ ! -d "$inputDir" ]; then
    echo "Error: Directory '$inputDir' does not exist. Exiting."
    exit 1
fi
# Check if utils folder exists
if [ ! -d "$utilsDir" ]; then
    echo "Error: Directory '$utilsDir' does not exist. Exiting."
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
    # extensionStylesheetLoader.sys.mjs                   # Extension Stylesheet Loader
    # findbarMods.uc.js                                   # Findbar Mods
    # fixTitlebarTooltips.uc.js                           # Fix Titlebar Button Tooltips
    # floatingSidebarResizer.uc.js                        # Floating Sidebar Resizer
    # autoHideNavbarSupport.uc.js                         # Auto-hide Navbar Support
    # hideTrackingProtectionIconOnCustomNewTabPage.uc.js  # Hide Tracking Protection Icon on Custom New Tab Page
    # # navbarToolbarButtonSlider.uc.js                     # Navbar Toolbar Button Slider
    # oneClickOneOffSearchButtons.uc.js                   # One-click One-off Search Buttons
    # removeSearchEngineAliasFormatting.uc.js             # Remove Search Engine Alias Formatting
    # restoreTabSoundButton.uc.js                         # Restore pre-Proton Tab Sound Button
    # # Restore pre-Proton Arrowpanels <- Handled in CSS # TODO currently is not integrated
    # restorePreProtonLibraryButton.uc.js                 # Restore pre-Proton Library Button
    # restorePreProtonStarButton.uc.js                    # Restore pre-Proton Star Button
    # scrollingOneOffs.uc.js                              # Scrolling Search One-offs
    # searchModeIndicatorIcons.uc.js                      # Search Mode Indicator Icons
    # showSelectedSidebarInSwitcherPanel.uc.js            # Show Selected Sidebar in Switcher Panel
    # tabLoadingSpinner.uc.js                             # Tab Loading Spinner Animation
    # tooltipShadowSupport.uc.js                          # Tooltip Shadow Support
    # tooltipStyler.uc.js                                 # Tooltip Styler
    # urlbarMods.uc.js                                    # Urlbar Mods
    # urlbarNotificationIconsOpenStatus.uc.js             # Add [open] Status to Urlbar Notification Icons
    # autocompletePopupStyler.uc.js                       # Autocomplete Popup Styler
    # userChromeAgentAuthorSheetLoader.sys.mjs            # Agent/Author Sheet Loader
    # userChromeDevtoolsSheetLoader.sys.mjs               # Browser Toolbox Stylesheet Loader # TODO currently is not integrated
    # osDetector.uc.js                                    # OS Detector
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

# Copy required utils from fx-autoconfig
cp "$utilsDir/profile/chrome/utils/"*.sys.mjs "$outputDir/utils/"


# Remove leftover files
if [ "$testMode" = false ]; then
    rm -f uc.css.js-master.zip
    rm -f fx-autoconfig-master.zip
    rm -rf uc.css.js-master
    rm -rf fx-autoconfig-master
fi

popd
