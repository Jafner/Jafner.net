{ ... }: {
  programs.mangohud = {
    enable = true;
    settings = {};
    settingsPerApplication = {};
  };
  home.file."MyConfig.conf" = {
    enable = true;
    target = ".config/MangoHud/MyConfig.conf";
    text = ''
      # FPS Limit
      fps_limit=240,0
      fps_limit_method=late
      # Software Information
      ##  FPS
      fps=0
      fps_color_change=0
      fps_text=
      fps_value=59,239
      fps_metrics=0

      ##  Frame Times
      frame_timing=1
      frame_timing_detailed=0
      dynamic_frame_timing=1
      frametime=0
      histogram=1
      show_fps_limit=0

      ##  Environment
      gamemode=0
      present_mode=0
      vulkan_driver=0
      engine_version=0
      engine_short_names=0
      exec_name=0
      vkbasalt=0
      wine=0
      winesync=0

      # Info: CPU
      cpu_text=
      cpu_stats=0
      core_load=0
      core_bars=0
      cpu_power=0
      cpu_temp=0

      # Info: GPU
      gpu_text=
      gpu_stats=0
      gpu_power=0
      gpu_temp=0
      gpu_core_clock=0
      gpu_mem_clock=0
      gpu_fan=0
      gpu_voltage=0
      throttling_status=0
      throttling_status_graph=0

      # Info: Memory
      procmem=0
      procmem_shared=0
      procmem_virt=0
      ram=0
      vram=0
      swap=0

      # Info: Network
      network=0

      # Info: Other
      time=0
      time_format=%r
      time_no_label=1

      graphs=

      # Keybindings
      toggle_hud=Shift_R+F12
      toggle_logging=Shift_L+F2
      toggle_hud_position=R_Shift+F11
      toggle_preset=Shift_R+F10
      toggle_fps_limit=Shift_L+F1
      reload_cfg=Shift_L+F4
      upload_log=Shift_L+F3
      reset_fps_metrics=Shift_R+f9

      # Orientation: positioning, size, arrangement
      width=240
      table_columns=2
      offset_x=3
      offset_y=24
      position=top-left
      legacy_layout=1
      height=0
      horizontal=0
      horizontal_stretch=0
      hud_compact=0
      hud_no_margin=1
      cellpadding_y=0
      round_corners=10

      alpha=1.000000
      background_alpha=1.00000

      # Text: Font, colors, etc.
      font_scale=1.0
      font_size=24
      font_size_text=24
      no_small_font=0

      text_color=cdd6f4
      text_outline=1
      text_outline_thickness=1
      text_outline_color=#1e1e2e

      frametime_color=b2bedc
      frametime_text_color=
      background_color=1d253a

      battery_color=ff0000#585b70
      engine_color=cdd6f4
      cpu_color=89b4fa
      cpu_load_color=a6e3a1, f9e2af, f38ba8
      io_color=f9e2af
      media_player_color=cdd6f4
      gpu_color=a6e3a1
      gpu_load_color=a6e3a1, f9e2af, f38ba8
      fps_color=a6e3a1, f9e2af, f38ba8
      wine_color=cba6f7
      vram_color=94e2d5
    '';
  };
  home.file."presets.conf" = {
    target = ".config/MangoHud/presets.conf";
    text = ''
      [preset 1] # Frame data
      fps=1
      fps_color_change=1
      fps_text=
      fps_value=59,239
      fps_metrics=avg,0.01

      frame_timing=1
      frame_timing_detailed=1
      dynamic_frame_timing=1
      frametime=1
      histogram=1

      show_fps_limit=1

      [preset 2] # CPU info
      cpu_text=5700X
      cpu_stats=1
      core_load=1
      core_bars=1
      cpu_power=0
      cpu_temp=1

      [preset 3] # GPU info
      gpu_text=7900 XTX
      gpu_stats=1
      gpu_power=1
      gpu_temp=1
      gpu_core_clock=1
      gpu_mem_clock=1
      gpu_fan=1
      gpu_voltage=1
      throttling_status=1
      throttling_status_graph=1

      [preset 4] # Memory info
      procmem=1
      procmem_shared=1
      procmem_virt=1
      ram=1
      vram=1
      swap=1

      [preset 5] # Network info
      network=enp4s0f0

      [preset 6] # Environment info
      gamemode=1
      present_mode=1
      vulkan_driver=1
      engine_version=1
      engine_short_names=1
      exec_name=1
      vkbasalt=1
      wine=1
      winesync=1

      [preset 7]
      no_display=1
    '';
  };
  home.sessionVariables = {
    MANGOHUD_CONFIGFILE = "$XDG_CONFIG_HOME/MangoHud/MyConfig.conf";
    MANGOHUD_PRESETSFILE = "$XDG_CONFIG_HOME/MangoHud/presets.conf";
  };
}

# OW HUD background: #1d253a
# OW HUD text: #b2bedc
# cat ~/.config/MangoHud/MangoHud.conf