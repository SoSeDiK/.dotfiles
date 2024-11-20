import { Process, Variable } from "astal";
import { Gtk } from "astal/gtk3";

const TIME_ICONS: { [key: number]: string } = {
  12: "󱑖",
  11: "󱑕",
  10: "󱑔",
  9: "󱑓",
  8: "󱑒",
  7: "󱑑",
  6: "󱑐",
  5: "󱑏",
  4: "󱑎",
  3: "󱑍",
  2: "󱑌",
  1: "󱑋",
};

function getTimeIcon(): string {
  var hour = parseInt(Process.exec('date "+%H"').trim());
  if (hour > 12) hour -= 12;
  else if (hour == 0) hour = 12;
  return TIME_ICONS[hour];
}

interface TimeStampProps {
  time: Variable<string>;
  pos: number;
  count: number;
}

function TimeStamp({ time, pos, count }: TimeStampProps) {
  const reverseTick = Variable<number | null>(-1);
  const tickData = Variable.derive([time(), reverseTick]);

  const lastChild = Variable<string>(time.get().charAt(pos));

  const stack = (
    <stack
      transitionDuration={reverseTick().as((rt) =>
        rt === null || rt === -1 ? 200 : 70
      )}
      transitionType={reverseTick().as((rt) => {
        return rt === null || rt === -1
          ? Gtk.StackTransitionType.SLIDE_UP
          : Gtk.StackTransitionType.SLIDE_DOWN;
      })}
      visibleChildName={tickData().as(([time, rt]) => {
        const id = time.charAt(pos);
        if (id === "0" && rt !== null && rt !== -1) return rt.toString();

        if (
          (rt === null || rt === -1) &&
          id === "0" &&
          lastChild.get() !== "0"
        ) {
          for (let t = 1; t < count; t++) {
            setTimeout(() => {
              reverseTick.set(count - 1 == t ? null : count - t);
            }, t * 70);
          }
        }

        lastChild.set(id);
        return id;
      })}
    >
      {Array.from({ length: 10 }, (_, i) => i + 1).map((i) => {
        const id = (i - 1).toString();
        return <label name={id} label={id}></label>;
      })}
    </stack>
  );
  return stack;
}

export default function TimeDate() {
  const date = Variable<string>("").poll(1000, () =>
    Process.exec('date "+%a %b %d"').trim()
  );
  const time = Variable<string>("000000").poll(1000, () =>
    Process.exec('date "+%H%M%S"').trim()
  );

  return (
    <box className="TimeDate bar_element">
      <label className="DateIcon" label={"󰃭"} />
      <label className="DateText" label={date()} />
      <label className="TimeIcon" label={time().as(() => getTimeIcon())} />
      <box className="TimeTextBox">
        <TimeStamp time={time} pos={0} count={3} />
        <TimeStamp time={time} pos={1} count={10} />
        <label label={":"} />
        <TimeStamp time={time} pos={2} count={6} />
        <TimeStamp time={time} pos={3} count={10} />
        <label label={":"} />
        <TimeStamp time={time} pos={4} count={6} />
        <TimeStamp time={time} pos={5} count={10} />
      </box>
    </box>
  );
}
