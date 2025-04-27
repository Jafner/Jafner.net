{ username, pkgs, ... }:
let
  mkMangohud = { bgColor, fgColor }:
  {
    fps = false;
    fps_color_change = false;
    fps_metrics = false;
    frame_timing = true;
    frame_timing_detailed = false;
    dynamic_frame_timing = true;
    frametime = false;
    histogram = true;
    show_fps_limit = false;
    gamemode = false;
    present_mode = false;
    vulkan_driver = false;
    engine_version = false;
    engine_short_names = false;
    exec_name = false;
    vkbasalt = false;
    wine = false;
    winesync = false;
    cpu_text = "";
    cpu_stats = false;
    core_load = false;
    core_bars = false;
    cpu_power = false;
    cpu_temp = false;
    gpu_text = "";
    gpu_stats = false;
    gpu_power = false;
    gpu_temp = false;
    gpu_core_clock = false;
    gpu_mem_clock = false;
    gpu_fan = false;
    gpu_voltage = false;
    throttling_status = false;
    throttling_status_graph = false;
    procmem = false;
    procmem_shared = false;
    procmem_virt = false;
    ram = false;
    vram = false;
    swap = false;
    network = false;
    time = false;
    time_no_label = true;
    graphs = "";

    width = 240;
    table_columns = 2;
    offset_x = 3;
    offset_y = 25;
    position = "top-left";
    legacy_layout = true;
    height = 0;
    horizontal = false;
    horizontal_stretch = false;
    hud_compact = false;
    hud_no_margin = true;
    cellpadding_y = 0;
    round_corners = 10;
    alpha = 1.000000;
    background_alpha = 1.000000;
    font_scale = 1.0;
    font_size = 24;
    font_size_text = 24;
    no_small_font = false;
    text_color = "cdd6f4";
    text_outline = true;
    text_outline_thickness = 1;
    text_outline_color = "1e1e2e";
    frametime_color = fgColor;
    frametime_text_color = "";
    background_color = bgColor;
    battery_color = "ff0000";
    engine_color = "cdd6f4";
    cpu_color = "89b4fa";
    cpu_load_color = "a6e3a1, f9e2af, f38ba8";
    io_color = "f9e2af";
    media_player_color = "cdd6f4";
    gpu_color = "a6e3a1";
    gpu_load_color = "a6e3a1, f9e2af, f38ba8";
    fps_color = "a6e3a1, f9e2af, f38ba8";
    wine_color = "cba6f7";
    vram_color = "94e2d5";
  };
in
{
  home-manager.users.${username} = {
    programs.mangohud = {
      enable = true;
      settingsPerApplication = {
        wine-Overwatch = mkMangohud {
          fgColor = "b2bedc";
          bgColor = "1d253a";
        };
      };
    };
  };
}
