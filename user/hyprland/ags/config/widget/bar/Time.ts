const time_icons = {
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

function getTimeIcon() {
  var hour = parseInt(Utils.exec('date "+%H"').trim());
  if (hour > 12) hour -= 12;
  else if (hour == 0) hour = 12;
  return time_icons[hour];
}

const date = Variable("", {
  poll: [1000, 'date "+%a %b %d"'],
});

const hm = Variable("", {
  poll: [1000, 'date "+%H:%M:%S"'],
});

const time = Utils.derive([date, hm], (date, hm) => {
  return "󰃭  " + date + "  " + getTimeIcon() + "  " + hm;
});

function Time() {
  return Widget.Button({
    class_name: "simple_box",
    child: Widget.Label({
      class_name: "time",
      label: time.bind(),
    }),
  });
}

export default () => Time();
