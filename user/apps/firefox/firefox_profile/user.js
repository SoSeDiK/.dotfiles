//
/* You may copy+paste this file and use it as it is.
 *
 * If you make changes to your about:config while the program is running, the
 * changes will be overwritten by the user.js when the application restarts.
 *
 * To make lasting changes to preferences, you will have to edit the user.js.
 */

/****************************************************************************
 * Betterfox                                                                *
 * "Ad meliora"                                                             *
 * version: 128                                                             *
 * url: https://github.com/yokoffing/Betterfox                              *
 ****************************************************************************/

/****************************************************************************
 * SECTION: FASTFOX                                                         *
 ****************************************************************************/
/** GENERAL ***/
user_pref("content.notify.interval", 100000);

/** GFX ***/
user_pref("gfx.canvas.accelerated.cache-items", 4096);
user_pref("gfx.canvas.accelerated.cache-size", 512);
user_pref("gfx.content.skia-font-cache-size", 20);

/** DISK CACHE ***/
user_pref("browser.cache.jsbc_compression_level", 3);

/** MEDIA CACHE ***/
user_pref("media.memory_cache_max_size", 65536);
user_pref("media.cache_readahead_limit", 7200);
user_pref("media.cache_resume_threshold", 3600);

/** IMAGE CACHE ***/
user_pref("image.mem.decode_bytes_at_a_time", 32768);

/** NETWORK ***/
user_pref("network.http.max-connections", 1800);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);
user_pref("network.http.pacing.requests.enabled", false);
user_pref("network.dnsCacheExpiration", 3600);
user_pref("network.ssl_tokens_cache_capacity", 10240);

/** SPECULATIVE LOADING ***/
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("network.prefetch-next", false);
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);

/** EXPERIMENTAL ***/
user_pref("layout.css.grid-template-masonry-value.enabled", true);
user_pref("dom.enable_web_task_scheduling", true);
user_pref("dom.security.sanitizer.enabled", true);

/****************************************************************************
 * SECTION: SECUREFOX                                                       *
 ****************************************************************************/
/** TRACKING PROTECTION ***/
user_pref("browser.contentblocking.category", "strict");
user_pref(
  "urlclassifier.trackingSkipURLs",
  "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com"
);
user_pref(
  "urlclassifier.features.socialtracking.skipURLs",
  "*.instagram.com, *.twitter.com, *.twimg.com"
);
user_pref("network.cookie.sameSite.noneRequiresSecure", true);
user_pref("browser.download.start_downloads_in_tmp_dir", true);
user_pref("browser.helperApps.deleteTempFileOnExit", true);
user_pref("browser.uitour.enabled", false);
user_pref("privacy.globalprivacycontrol.enabled", true);

/** OCSP & CERTS / HPKP ***/
user_pref("security.OCSP.enabled", 0);
user_pref("security.remote_settings.crlite_filters.enabled", true);
user_pref("security.pki.crlite_mode", 2);

/** SSL / TLS ***/
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("browser.xul.error_pages.expert_bad_cert", true);
user_pref("security.tls.enable_0rtt_data", false);

/** DISK AVOIDANCE ***/
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("browser.sessionstore.interval", 60000);

/** SHUTDOWN & SANITIZING ***/
user_pref("privacy.history.custom", true);

/** SEARCH / URL BAR ***/
user_pref("browser.urlbar.trimHttps", true);
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);
user_pref("browser.urlbar.update2.engineAliasRefresh", true);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.quicksuggest.enabled", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.groupLabels.enabled", false);
user_pref("browser.formfill.enable", false);
user_pref("security.insecure_connection_text.enabled", true);
user_pref("security.insecure_connection_text.pbmode.enabled", true);
user_pref("network.IDN_show_punycode", true);

/** HTTPS-FIRST POLICY ***/
user_pref("dom.security.https_first", true);
user_pref("dom.security.https_first_schemeless", true);

/** PASSWORDS ***/
user_pref("signon.formlessCapture.enabled", false);
user_pref("signon.privateBrowsingCapture.enabled", false);
user_pref("network.auth.subresource-http-auth-allow", 1);
user_pref("editor.truncate_user_pastes", false);

/** MIXED CONTENT + CROSS-SITE ***/
user_pref("security.mixed_content.block_display_content", true);
user_pref("pdfjs.enableScripting", false);
user_pref("extensions.postDownloadThirdPartyPrompt", false);

/** HEADERS / REFERERS ***/
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

/** CONTAINERS ***/
user_pref("privacy.userContext.ui.enabled", true);

/** WEBRTC ***/
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);
user_pref("media.peerconnection.ice.default_address_only", true);

/** SAFE BROWSING ***/
user_pref("browser.safebrowsing.downloads.remote.enabled", false);

/** MOZILLA ***/
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.geo", 2);
user_pref("permissions.manager.defaultsUrl", "");
user_pref("webchannel.allowObject.urlWhitelist", "");

/** TELEMETRY ***/
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

/** EXPERIMENTS ***/
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

/** CRASH REPORTS ***/
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

/** DETECTION ***/
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);
user_pref("network.connectivity-service.enabled", false);
user_pref("dom.private-attribution.submission.enabled", false);

/****************************************************************************
 * SECTION: PESKYFOX                                                        *
 ****************************************************************************/
/** MOZILLA UI ***/
user_pref("browser.privatebrowsing.vpnpromourl", "");
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref(
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons",
  false
);
user_pref(
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features",
  false
);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.tabs.tabmanager.enabled", false);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.aboutwelcome.enabled", false);

/** THEME ADJUSTMENTS ***/
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.display.focus_ring_on_anything", true);
user_pref("browser.display.focus_ring_style", 0);
user_pref("browser.display.focus_ring_width", 0);
user_pref("layout.css.prefers-color-scheme.content-override", 2);
user_pref("browser.privateWindowSeparation.enabled", false); // WINDOWS

/** COOKIE BANNER HANDLING ***/
user_pref("cookiebanners.service.mode", 1);
user_pref("cookiebanners.service.mode.privateBrowsing", 1);

/** FULLSCREEN NOTICE ***/
user_pref("full-screen-api.transition-duration.enter", "0 0");
user_pref("full-screen-api.transition-duration.leave", "0 0");
user_pref("full-screen-api.warning.delay", -1);
user_pref("full-screen-api.warning.timeout", 0);

/** URL BAR ***/
user_pref("browser.urlbar.suggest.calculator", true);
user_pref("browser.urlbar.unitConversion.enabled", true);
user_pref("browser.urlbar.trending.featureGate", false);

/** NEW TAB PAGE ***/
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

/** POCKET ***/
user_pref("extensions.pocket.enabled", false);

/** DOWNLOADS ***/
user_pref("browser.download.always_ask_before_handling_new_types", true);
user_pref("browser.download.manager.addToRecentDocs", false);

/** PDF ***/
user_pref("browser.download.open_pdf_attachments_inline", true);

/** TAB BEHAVIOR ***/
user_pref("browser.bookmarks.openInTabClosesMenu", false);
user_pref("browser.menu.showViewImageInfo", true);
user_pref("findbar.highlightAll", true);
user_pref("layout.word_select.eat_space_to_next_word", false);

/****************************************************************************
 * START: MY OVERRIDES                                                      *
 ****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/wiki/Common-Overrides
// visit https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening
// Enter your personal overrides below this line:

/****************************************************************************
 * SECTION: SMOOTHFOX                                                       *
 ****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
// Enter your scrolling overrides below this line:
/****************************************************************************************
 * OPTION: NATURAL SMOOTH SCROLLING V3 [MODIFIED]                                      *
 ****************************************************************************************/
// credit: https://github.com/AveYo/fox/blob/cf56d1194f4e5958169f9cf335cd175daa48d349/Natural%20Smooth%20Scrolling%20for%20user.js
// recommended for 120hz+ displays
// largely matches Chrome flags: Windows Scrolling Personality and Smooth Scrolling
user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
user_pref("general.smoothScroll", true); // DEFAULT
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", "2");
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
user_pref("general.smoothScroll.currentVelocityWeighting", "1");
user_pref("general.smoothScroll.stopDecelerationWeighting", "1");
user_pref("mousewheel.default.delta_multiplier_y", 300); // 250-400; adjust this number to your liking

/****************************************************************************
 * END: BETTERFOX                                                           *
 ****************************************************************************/

/****************************************************************************
 * START: UC.CSS.JS Recommended prefs                                          *
 ****************************************************************************/
////// ⚠️ REQUIRED PREFS

//// disable telemetry since we're modding firefox
user_pref("toolkit.telemetry.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref(
  "datareporting.healthreport.documentServerURI",
  "http://%(server)s/healthreport/"
);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
//// make the theme work properly
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.proton.places-tooltip.enabled", true);
user_pref("layout.css.moz-document.content.enabled", true);
//// eliminate the blank white window during startup
user_pref("browser.startup.blankWindow", false);
user_pref("browser.startup.preXulSkeletonUI", false);
////
// required for icons with data URLs
user_pref("svg.context-properties.content.enabled", true);
// required for acrylic gaussian blur
user_pref("layout.css.backdrop-filter.enabled", true);
// enable browser dark mode
user_pref("ui.systemUsesDarkTheme", 1);
// enable content dark mode
user_pref("layout.css.prefers-color-scheme.content-override", 0);
// allow the color-mix() CSS function
user_pref("layout.css.color-mix.enabled", true);
// other CSS features
user_pref("layout.css.moz-outline-radius.enabled", true);
//// avoid native styling
user_pref("browser.display.windows.non_native_menus", 1);
user_pref("widget.content.allow-gtk-dark-theme", true);
////
// avoid custom menulist/select styling
user_pref("dom.forms.select.customstyling", false);
// keep "all tabs" menu available at all times, useful for all tabs menu
// expansion pack
user_pref("browser.tabs.tabmanager.enabled", true);
// disable urlbar result group labels since we don't use them
user_pref("browser.urlbar.groupLabels.enabled", false);
// allow urlbar result menu buttons without slowing down tabbing through results
user_pref("browser.urlbar.resultMenu.keyboardAccessible", false);
// corresponds to the system color Highlight
user_pref("ui.highlight", "hsl(250, 100%, 60%)");
// Background for selected <option> elements and others
user_pref("ui.selecteditem", "#2F3456");
// Text color for selected <option> elements and others
user_pref("ui.selecteditemtext", "#FFFFFFCC");
//// Tooltip colors (only relevant if userChrome.ag.css somehow fails to apply,
//// but doesn't hurt)
user_pref("ui.infotext", "#FFFFFF");
user_pref("ui.infobackground", "#hsl(233, 36%, 11%)");
////

// ⚠️ REQUIRED on macOS
user_pref("widget.macos.native-context-menus", false);

////// ✨ RECOMMENDED PREFS

//// allow installing the unsigned search extensions. the localized search
//// extensions currently can't be signed because of
//// https://github.com/mozilla/addons-linter/issues/3911 so to use them, we
//// must disable the signature requirement and go to about:addons > gear icon >
//// install addon from file > find the .zip file
user_pref("xpinstall.signatures.required", false);
user_pref("extensions.autoDisableScopes", 0);
//// functionality oriented prefs
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("browser.display.use_system_colors", false);
user_pref("browser.privatebrowsing.enable-new-indicator", false);
user_pref("accessibility.mouse_focuses_formcontrol", 0);
user_pref("browser.tabs.tabMinWidth", 90);
user_pref("browser.urlbar.accessibility.tabToSearch.announceResults", false);
// disable large urlbar suggestions for now. they are styled so this is not
// required, but I don't find them useful since they only seem to appear when
// the urlbar is empty and search engine is set to google.
user_pref("browser.urlbar.richSuggestions.featureGate", false);
// but enable the rich one-line suggestions that appear when typing long search
// terms and guess an end to the sentence
user_pref("browser.urlbar.richSuggestions.tail", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.trimURLs", false);
// hide fullscreen enter/exit warning
user_pref("full-screen-api.transition-duration.enter", "0 0");
user_pref("full-screen-api.transition-duration.leave", "0 0");
user_pref("full-screen-api.warning.delay", -1);
user_pref("full-screen-api.warning.timeout", 0);
// whether to show content dialogs within tabs or above tabs
user_pref("prompts.contentPromptSubDialog", true);
// when using the keyboard to navigate menus, skip past disabled items
user_pref("ui.skipNavigatingDisabledMenuItem", 1);
user_pref("ui.prefersReducedMotion", 0);
// reduce the delay before showing submenus (e.g. View > Toolbars)
user_pref("ui.submenuDelay", 100);
// the delay before a tooltip appears when hovering an element (default 300ms)
user_pref("ui.tooltipDelay", 300);
// should pressing the Alt key alone focus the menu bar?
user_pref("ui.key.menuAccessKeyFocuses", false);
// reduce update frequency
user_pref("app.update.suppressPrompts", true);
////

//// style oriented prefs
// use GTK style for in-content scrollbars
user_pref("widget.non-native-theme.scrollbar.style", 2);
//// set the scrollbar style and width
user_pref("widget.non-native-theme.win.scrollbar.use-system-size", false);
user_pref("widget.non-native-theme.scrollbar.size.override", 11);
user_pref("widget.non-native-theme.gtk.scrollbar.thumb-size", "0.818");
//// base color scheme prefs
user_pref("browser.theme.content-theme", 0);
user_pref("browser.theme.toolbar-theme", 0);
// set the default background color for color-scheme: dark. see it for example
// on about:blank
user_pref("browser.display.background_color.dark", "#19191b");
////
// make `outline-style: auto` result in one big stroke instead of two
// contrasting strokes
user_pref("widget.non-native-theme.solid-outline-style", true);
//// findbar highlight and selection colors
user_pref("ui.textHighlightBackground", "#7755FF");
user_pref("ui.textHighlightForeground", "#FFFFFF");
user_pref("ui.textSelectBackground", "#FFFFFF");
user_pref("ui.textSelectAttentionBackground", "#FF3388");
user_pref("ui.textSelectAttentionForeground", "#FFFFFF");
user_pref("ui.textSelectDisabledBackground", "#7755FF");
user_pref("ui.textSelectBackgroundAttention", "#FF3388");
user_pref("ui.textSelectBackgroundDisabled", "#7755FF");
//// spell check style
user_pref("ui.SpellCheckerUnderline", "#E2467A");
user_pref("ui.SpellCheckerUnderlineStyle", 1);
//// IME style (for example when typing pinyin or hangul)
user_pref("ui.IMERawInputBackground", "#000000");
user_pref("ui.IMESelectedRawTextBackground", "#7755FF");
////
// about:reader dark mode
user_pref("reader.color_scheme", "dark");

//// font settings
user_pref("layout.css.font-visibility.private", 3);
user_pref("layout.css.font-visibility.resistFingerprinting", 3);
////

//// windows font settings - does nothing on macOS or linux
user_pref("gfx.font_rendering.cleartype_params.cleartype_level", 100);
user_pref(
  "gfx.font_rendering.cleartype_params.force_gdi_classic_for_families",
  ""
);
user_pref("gfx.font_rendering.cleartype_params.force_gdi_classic_max_size", 6);
user_pref("gfx.font_rendering.cleartype_params.pixel_structure", 1);
user_pref("gfx.font_rendering.cleartype_params.rendering_mode", 5);
user_pref("gfx.font_rendering.directwrite.use_gdi_table_loading", false);
////

//// recommended userChrome... prefs created by the theme or scripts. there are
//// many more not included here, to allow a lot more customization. these are
//// just the ones I'm pretty certain 90% of users will want. see the prefs list
//// at https://github.com/aminomancer/uc.css.js
user_pref("userChrome.tabs.pinned-tabs.close-buttons.disabled", true);
user_pref("userChrome.urlbar-results.hide-help-button", true);
// add a drop shadow on menupopup and panel elements (e.g. context menus)
user_pref("userChrome.css.menupopup-shadows", true);
//// these are more subjective prefs, but they're important ones
//// display the all tabs menu in reverse order (newer tabs on top, like history)
// user_pref("userChrome.tabs.all-tabs-menu.reverse-order", true);
// turn bookmarks on the toolbar into small square buttons with no text labels
// user_pref("userChrome.bookmarks-toolbar.icons-only", false);
// replace UI font with SF Pro, the system font for macOS.
// recommended for all operating systems, but not required.
// must have the fonts installed. check the repo's readme for more details.
user_pref("userChrome.css.mac-ui-fonts", true);
// custom wikipedia dark mode theme
// user_pref("userChrome.css.wikipedia.dark-theme-enabled", true);

/****************************************************************************
 * START: MY OVERRIDES                                                      *
 ****************************************************************************/

// Custom values

// BETTERFOX Overrides
// Save downloads to default folder
user_pref("browser.download.useDownloadDir", true);
// Restore search engine suggestions
user_pref("browser.search.suggest.enabled", true);
// Better touchpad scrolling
user_pref("apz.gtk.pangesture.delta_mode", 2);
user_pref("apz.gtk.pangesture.pixel_delta_mode_multiplier", 10);

// UC.CSS.JS Overrides
// Only slide right side of toolbar
user_pref("userChrome.toolbarSlider.wrapButtonsRelativeToUrlbar", "after"); // after/before/all
// Allow up to X icons for a slider
user_pref("userChrome.toolbarSlider.width", 50);
// Exclude some items from the slider
user_pref(
  "userChrome.toolbarSlider.excludeButtons",
  '["downloads-button", "simple-tab-groups_drive4ik-browser-action", "_446900e4-71c2-419f-a6a7-df9c091e268b_-BAP", "multithreaded-download-manager_qw_linux-2g64_local-BAP", "ublock0_raymondhill_net-BAP", "addon_darkreader_org-BAP", "_8d1582b2-ff2a-42e0-ba40-42f4ebfe921b_-BAP"]' // Downloads, Simple Tab Groups, Bitwarder, Multithreaded Download Manager, uBlock Origin, Dark Reader, Notifier for GitHub
);
// Exclude flexible space from slider
user_pref("userChrome.toolbarSlider.excludeFlexibleSpace", true);
// Require holding modifier key for extra tab toolip
user_pref("tabTooltipNavButtons.modifierKey", "shift");
// Don't use right/left arrow keys to navigate between search engines
user_pref("userChrome.urlbar.oneOffs.keyNavigation", false);
