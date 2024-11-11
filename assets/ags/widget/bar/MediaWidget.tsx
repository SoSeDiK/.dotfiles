import { bind } from "astal";
import { Astal, Gtk } from "astal/gtk3";
import Mpris from "gi://AstalMpris";
import Hyprland from "gi://AstalHyprland";

const PLAY_ICON = "";
const PAUSE_ICON = "";
const PREV_ICON = "󰒮";
const NEXT_ICON = "󰒭";

function fnToFilterForSpotify(
  players: AstalMpris.Player[]
): AstalMpris.Player | null {
  if (players.length === 0) return null;

  const player = players.find((player) => player.identity === "Spotify");
  return player || players[0];
}

function trackPosition(player: AstalMpris.Player): number {
  const value = player.position / player.length;
  return value > 0 ? value : 0;
}

function Media({ player }: { player: AstalMpris.Player }) {
  return (
    <box>
      <box
        className="Cover"
        valign={Gtk.Align.CENTER}
        visible={bind(player, "coverArt").as((cover) => cover !== null)}
        css={bind(player, "coverArt").as(
          (cover) => `background-image: url('${cover}');`
        )}
        tooltipText={bind(player, "title")}
      />
      <box className="Controls">
        <button
          className="Previous"
          cursor="pointer"
          onClicked={() => player.previous()}
        >
          <label label={PREV_ICON} />
        </button>
        <button
          className="PlayPause"
          cursor="pointer"
          onClicked={() => player.play_pause()}
          onClickRelease={(_, event) => {
            if (event.button === Astal.MouseButton.MIDDLE)
              Hyprland.get_default().dispatch(
                "togglespecialworkspace",
                "music"
              );
          }}
        >
          <circularprogress
            css="min-width: 20px; min-height: 20px; font-size: 10px; background-color: #131313; color: #B2B0E5;"
            startAt={0.75}
            endAt={-0.25}
            value={bind(player, "position").as(() => trackPosition(player))}
          >
            <label
              css="color: white;"
              label={bind(player, "playbackStatus").as((status) =>
                status === 0 ? PAUSE_ICON : PLAY_ICON
              )}
            />
          </circularprogress>
        </button>
        <button
          className="Next"
          cursor="pointer"
          onClicked={() => player.next()}
        >
          <label label={NEXT_ICON} />
        </button>
      </box>
    </box>
  );
}

function SpotifySuggetion() {
  return (
    <button
      onClickRelease={(_, event) => {
        if (
          event.button === Astal.MouseButton.MIDDLE ||
          event.button === Astal.MouseButton.PRIMARY
        )
          Hyprland.get_default().dispatch("togglespecialworkspace", "music");
      }}
    >
      {" "}
    </button>
  );
}

export default function MediaWidget() {
  const mpris = Mpris.get_default();

  return (
    <box className="Media bar_element">
      {bind(mpris, "players").as((ps) => {
        const player = fnToFilterForSpotify(ps);
        if (!player) return <SpotifySuggetion />;
        return <Media player={player} />;
      })}
    </box>
  );
}
