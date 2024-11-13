import { Variable, bind, execAsync } from "astal";
import { App, Astal, Gdk, Gtk } from "astal/gtk3";
import Wp from "gi://AstalWp";
import { Separator } from "../misc/Separator";

export const audioOptionsVisible = Variable(false);

export const AudioOptionsMenu = (monitor: Gdk.Monitor) => {
  const audio = Wp.get_default()?.audio!;
  const speaker = audio.defaultSpeaker!;

  const StreamVolume = (stream: Wp.Endpoint) => (
    <box>
      <button
        className="MuteButton"
        cursor="pointer"
        onClicked={() => (stream.mute = !stream.mute)}
      >
        <label label={bind(stream, "mute").as((mute) => (mute ? "󰝟" : "󰕾"))} />
      </button>
      <box vertical>
        <label
          className="SinkName"
          halign={Gtk.Align.START}
          label={bind(stream, "description")}
        />
        <box>
          <slider
            className="simple_slider"
            hexpand
            cursor="pointer"
            onDragged={({ value }) => (stream.volume = value)}
            value={bind(stream, "volume")}
          />
          <label
            label={bind(stream, "volume").as((v) => {
              let p = Math.floor(v * 100) + "%";
              while (p.length < 4) p = " " + p;
              return p;
            })}
          />
        </box>
      </box>
    </box>
  );

  return (
    <window
      className="AudioOptions menu"
      visible={bind(audioOptionsVisible)}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
      setup={(self) => App.add_window(self)}
    >
      <box className="menu_window_box" vertical>
        <box vertical className="menu_box">
          <box vertical className="SpeakerVolume">
            <box>
              <label
                className="header"
                hexpand
                halign={Gtk.Align.START}
                label="Volume"
              />
              <button
                className="EqualizerButton"
                cursor="pointer"
                onClicked={() => {
                  execAsync("easyeffects");
                  audioOptionsVisible.set(false);
                }}
                tooltipText="Equalizer Settings"
              >
                <label label="󱝉" />
              </button>
            </box>
            <box>
              <button
                className="MuteButton"
                cursor="pointer"
                onClicked={() => (speaker.mute = !speaker.mute)}
              >
                <label
                  label={bind(speaker, "mute").as((mute) => (mute ? "󰝟" : "󰕾"))}
                />
              </button>
              <box vertical>
                <label
                  className="SinkName"
                  halign={Gtk.Align.START}
                  label={bind(speaker, "description").as((description) => {
                    if (!description) return "Unknown Speaker";
                    if (description.length > 24)
                      return description.substring(0, 24).trim() + "…";
                    return description;
                  })}
                />
                <box>
                  <slider
                    className="simple_slider"
                    cursor="pointer"
                    hexpand
                    onDragged={({ value }) => (speaker.volume = value)}
                    value={bind(speaker, "volume")}
                  />
                  <label
                    label={bind(speaker, "volume").as((v) => {
                      let p = Math.floor(v * 100) + "%";
                      while (p.length < 4) p = " " + p;
                      return p;
                    })}
                  />
                </box>
              </box>
            </box>
          </box>

          <Separator />

          <box vertical className="AppVolumes">
            <label
              className="header"
              visible={bind(audio, "streams").as(
                (streams) => streams.length > 0
              )}
              halign={Gtk.Align.START}
              label="Apps"
            />
            {bind(audio, "streams").as((streams) => streams.map(StreamVolume))}
          </box>
        </box>
      </box>
    </window>
  );
};

export default function AudioWidget() {
  const audio = Wp.get_default()?.audio!;
  const speaker = audio.defaultSpeaker!;
  const microphone = audio.defaultMicrophone!;

  const audioChange = Variable.derive([
    bind(speaker, "volume"),
    bind(speaker, "mute"),
  ]);

  return (
    <box className="Audio bar_element">
      <button
        cursor="pointer"
        onClicked={() => audioOptionsVisible.set(!audioOptionsVisible.get())}
        onClickRelease={(_, event) => {
          if (event.button === Astal.MouseButton.MIDDLE) {
            speaker.mute = !speaker.mute;
          }
        }}
      >
        <label
          label={bind(audioChange).as(() => {
            const vol = Math.floor(speaker.volume * 100);
            const icon = speaker.mute
              ? "󰝟"
              : [
                  [101, "󱄡"],
                  [67, "󰕾"],
                  [34, "󰖀"],
                  [1, "󰕿"],
                  [0, "󰸈"],
                ].find(
                  ([threshold]) => parseInt(threshold.toString()) <= vol
                )?.[1];

            return `${icon} ${Math.floor(vol)}%`;
          })}
        />
      </button>
      <label visible={bind(microphone, "mute")} label={"󰍭"} />
    </box>
  );
}
