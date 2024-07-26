import PopupWindow from "widget/misc/PopupWindow";
import { MprisPlayer } from "types/service/mpris";
import { openMenu } from "lib/utils";

const audio = await Service.import("audio");
const mpris = await Service.import("mpris");
const hyprland = await Service.import("hyprland");

const PLAY_ICON = "";
const PAUSE_ICON = "";
const PREV_ICON = "󰒮";
const NEXT_ICON = "󰒭";

const AUDIO_WINDOW = "AudioMenu";

const dispatchMusicWorkspace = () =>
  hyprland.messageAsync(`dispatch togglespecialworkspace music`);

function getPlayIcon(status: string | null) {
  switch (status) {
    case "Playing":
      return PAUSE_ICON;
    case "Paused":
    case "Stopped":
      return PLAY_ICON;
  }
  return PLAY_ICON;
}

function MediaWidget() {
  const player: MprisPlayer | null = mpris?.players[0];

  const prevButton = Widget.Button({
    css: "padding-left: 4px;",
    class_names: ["media_previous", "no_initial_bg"],
    onClicked: () => player?.previous(),
    onMiddleClick: dispatchMusicWorkspace,
    child: Widget.Label({ label: PREV_ICON }),
  });

  const nextButton = Widget.Button({
    css: "padding-right: 4px;",
    class_names: ["media_next", "no_initial_bg"],
    onClicked: () => player?.next(),
    onMiddleClick: dispatchMusicWorkspace,
    child: Widget.Label({ label: NEXT_ICON }),
  });

  const playPause = Widget.Label({
    css: "color: white;",
    label: getPlayIcon(player?.play_back_status),
    setup: (self) => {
      self.hook(player, () => {
        self.label = getPlayIcon(player?.play_back_status);
      });
    },
  });

  const playButton = Widget.Button({
    css: "padding: 0 6px;",
    class_names: ["media_play", "no_initial_bg"],
    onClicked: () => player?.playPause(),
    onMiddleClick: dispatchMusicWorkspace,
    child: Widget.CircularProgress({
      css:
        "min-width: 20px; min-height: 20px;" + // size
        "font-size: 10px;" + // thickness
        "background-color: #131313;" + // bg color
        "color: #B2B0E5;", // fg color
      rounded: false,
      startAt: 0.75, // top
      child: playPause,
      setup: (self) => {
        function update() {
          if (!player) {
            self.value = 0;
            return;
          }

          const value = player?.position / player?.length;
          self.value = value > 0 ? value : 0;
        }
        self.hook(player, update);
        self.hook(player, update, "position");
        self.poll(1000, update);
      },
    }),
  });

  return Widget.Box({
    css: "padding: 0 8px;",
    tooltip_text: player?.identity || "",
    class_names: ["media_widget", "simple_box"],
    child: Widget.Box({
      children: [prevButton, playButton, nextButton],
    }),
    setup: (self) => {
      self.hook(player, () => {
        self.tooltip_text = player?.identity || null;
      });
    },
  });
}

function AudioWidget() {
  const volumeIndicator = Widget.Button({
    class_names: ["audio_widget", "simple_box"],
    onPrimaryClick: () => openMenu(AUDIO_WINDOW),
    onSecondaryClick: () =>
      (audio.microphone.is_muted = !audio.microphone.is_muted),
    onMiddleClick: () => (audio.speaker.is_muted = !audio.speaker.is_muted),
    onScrollUp: () => (audio.speaker.volume += 0.05),
    onScrollDown: () => (audio.speaker.volume -= 0.05),
    child: Widget.Box({
      children: [
        Widget.Label().hook(audio.speaker, (self) => {
          const vol = audio.speaker.volume * 100;
          const icon = audio.speaker.is_muted
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

          self.label = `${icon} ${Math.floor(vol)}%`;
        }),
        Widget.Label({
          css: "color: gray;",
          label: " 󰍭",
        }).hook(audio.microphone, (self) => {
          self.visible = audio.microphone.is_muted || false;
        }),
      ],
    }),
  });

  return volumeIndicator;
}

export const AudioMenu = () => {
  const audioSlider = Widget.Box({
    css: "background-color: #1b1b29; padding: 16px; border-radius: 10px;",
    vertical: true,
    spacing: 8,
    children: [
      Widget.Box({
        children: [
          Widget.Label({
            label: "Volume",
            hexpand: true,
            hpack: "start",
          }),
          Widget.Button({
            class_names: ["no_initial_bg"],
            onClicked: () => Utils.execAsync("easyeffects"),
            child: Widget.Label({ label: "󱝉" }),
            tooltip_text: "Equalizer Settings",
          }),
        ],
      }),
      Widget.Box({
        spacing: 8,
        children: [
          Widget.Button({
            vpack: "end",
            class_names: ["no_initial_bg"],
            onClicked: () => (audio.speaker.is_muted = !audio.speaker.is_muted),
            child: Widget.Label().hook(audio.speaker, (self) => {
              self.css = `color: ${
                audio.speaker.is_muted ? "gray" : "white"
              }; padding: 0 4px;`;
              self.label = audio.speaker.is_muted ? "󰝟" : "󰕾";
            }),
          }),
          Widget.Box({
            vertical: true,
            spacing: 8,
            children: [
              Widget.Label({
                truncate: "end",
                wrap: true,
              }).hook(audio.speaker, (self) => {
                self.label = audio.speaker.description || "Unkown Speaker";
              }),
              Widget.Slider({
                hexpand: true,
                draw_value: false,
                onChange: ({ value }) => (audio.speaker.volume = value),
                setup: (self) =>
                  self.hook(audio.speaker, () => {
                    self.value = audio.speaker.volume || 0;
                  }),
              }),
            ],
          }),
          Widget.Label({
            vpack: "end",
          }).hook(audio.speaker, (self) => {
            const vol = Math.floor(audio.speaker.volume * 100);
            self.label = vol + "%";
          }),
        ],
      }),
    ],
  });

  const popup = Widget.Box({
    css: "min-width: 320px; background-color: #131313; padding: 16px; border-radius: 10px;",
    child: Widget.Box({
      vertical: true,
      children: [audioSlider],
    }),
  });

  return PopupWindow({
    name: AUDIO_WINDOW,

    class_name: "audio_menu",
    visible: false,
    keymode: "exclusive",
    child: popup,
    anchor: ["top", "right"],
  });
};

export { MediaWidget, AudioWidget };
