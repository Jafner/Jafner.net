{ lib, ... }: {
  programs.mangohud = {
    enable = true;
    settings = {
      # Metrics
      cpu_stats = 0;
      gpu_stats = 0; 
      frame_timing = 0;
      vram = 0;
      fps = 1;
      fps_color_change = 1;
      fps_value = "59,239";
      frametime = 1;
      # Env info
      vulkan_driver = 1;
      gamemode = 1;
      present_mode = 0;
      throttling_status = 1;
      # Graphs
      graphs = "";
      # Appearance & presentation
      legacy_layout = 1;
      hud_no_margin = 1;
      font_size = lib.mkForce 14;
      no_small_font = 1;
      position = "top-left";
      offset_x = 3;
      offset_y = 24;
      width = 0;
      height = 0;
      table_columns = 0;
      horizontal = 1;
      horizontal_stretch = 0;
      hud_compact = 1;
      toggle_hud = "Shift_R+F12";
      background_alpha = lib.mkForce 0.5;
      alpha = lib.mkForce 1.0;
    };
  };
}

# OW HUD background: #1d253a
# OW HUD text: #b2bedc
# cat ~/.config/MangoHud/MangoHud.conf