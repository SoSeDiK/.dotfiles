{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];

  # Run legion_gui as root
  security.wrappers.legion_gui_with_cap = {
    owner = "root";
    group = "root";
    capabilities = "cap_dac_override,cap_dac_read_search,cap_sys_rawio,cap_sys_admin+p";
    source = "${pkgs.lenovo-legion}/bin/legion_gui";
  };
}
