const parseProfile = (profile: string): PowerProfileType => {
  profile = profile.trim();
  if (profile === "quiet") return "power-saver";
  return profile as PowerProfileType;
};
const get = () => parseProfile(String(Utils.exec("powerprofilesctl get")));

export type PowerProfileType =
  | "power-saver"
  | "balanced"
  | "performance"
  | "balanced-performance";

class PowerProfiles extends Service {
  static {
    Service.register(
      this,
      {},
      {
        power_profile: ["string", "rw"],
      }
    );
  }

  get available() {
    return Utils.exec(
      "which powerprofilesctl",
      () => true,
      () => false
    );
  }

  #profile: PowerProfileType = get();

  get profile() {
    return this.#profile;
  }

  get profiles(): PowerProfileType[] {
    return ["power-saver", "balanced", "performance", "balanced-performance"];
  }

  set profile(value: PowerProfileType) {
    Utils.execAsync(`powerprofilesctl set ${value}`).then(() => {
      this.#profile = value;
      print(`Updated to: ${this.profile} (set)`);
      this.changed("profile");
    });
  }

  constructor() {
    super();

    const profilePath = `/sys/firmware/acpi/platform_profile`;

    Utils.monitorFile(profilePath, async (f) => {
      const v = await Utils.readFileAsync(f);
      this.#profile = parseProfile(v);
      print(`Updated to: ${this.profile} (file)`);
      this.changed("profile");
    });
  }
}

export default new PowerProfiles();
