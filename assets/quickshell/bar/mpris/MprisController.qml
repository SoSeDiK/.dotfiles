pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

import QtQuick
import QtQuick.Layouts

Singleton {
    property MprisPlayer trackedPlayer: null;
	property MprisPlayer activePlayer: trackedPlayer ?? findSpotifyPlayer() ?? null;

    property bool isPlaying: activePlayer && activePlayer.isPlaying;
    property real progress: (activePlayer && activePlayer.positionSupported && activePlayer.lengthSupported) ? activePlayer.position / activePlayer.length : 0

	property bool canTogglePlaying: activePlayer?.canTogglePlaying ?? false;
	function togglePlaying() {
		if (canTogglePlaying)
            activePlayer.togglePlaying();
	}

	property bool canGoPrevious: activePlayer?.canGoPrevious ?? false;
	function previous() {
		if (canGoPrevious)
            activePlayer.previous();
	}

	property bool canGoNext: activePlayer?.canGoNext ?? false;
	function next() {
		if (canGoNext)
            activePlayer.next();
	}

    FrameAnimation {
        running: activePlayer?.playbackState == MprisPlaybackState.Playing;
        onTriggered: activePlayer.positionChanged()
    }

	function findSpotifyPlayer() {
		return Mpris.players.values.find(p => p.identity === "Spotify") || Mpris.players.values[0];
	}
}
