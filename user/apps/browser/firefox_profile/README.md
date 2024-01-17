Firefox profile consists of the following things:
- betterfox
- uc.css.js


<!-- Please don't change or delete the template -->

**Link to the file containing the bug**
[openBookmarkInContainerTab.uc.js](https://github.com/aminomancer/uc.css.js/blob/master/JS/openBookmarkInContainerTab.uc.js)

**Describe the bug**
Enabling the script leads to tab's context menu have no text:

**To Reproduce**
Steps to reproduce the behavior:
1. Add `openBookmarkInContainerTab.uc.js` to `chrome/JS`
2. Click with RMB on a tab with the script enabled
3. Observe the bug

**Expected behavior**
Tab's context menu displays the text normally.

**Screenshots**
Context menu before and after adding the script:
![screenshot-2024-01-16-07:38:01](https://github.com/aminomancer/uc.css.js/assets/19875118/c22f2f74-c02d-415a-a9fc-b764e9aae72a) ![screenshot-2024-01-16-07:37:01](https://github.com/aminomancer/uc.css.js/assets/19875118/75223df4-c011-4110-b1b7-b605429edb2c)

**Desktop (please complete the following information):**
 - OS: [e.g. Windows 10, Ubuntu 21]
 - Firefox update channel: [should be Nightly]
 - Version: [e.g. 96.0a1]
 - Build ID: [e.g. 20211111045525]
<!-- Search for extensions.lastAppBuildId in about:config and copy + paste the value here.
Or you can type Services.appinfo.platformBuildID in the browser toolbox console and hit enter -->

**Additional context**
Add any other context about the problem here.

