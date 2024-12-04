-- Universal config file
-- see https://github.com/wez/wezterm/discussions/4728 for hints on OS detection

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Check OS
-- https://github.com/wez/wezterm/discussions/4728
local is_darwin <const> = wezterm.target_triple:find("darwin") ~= nil
local is_linux <const> = wezterm.target_triple:find("linux") ~= nil
local is_windows <const> = wezterm.target_triple:find("windows") ~= nil
-- dim the background image
local bg_dimmer = {
  hue = 1.0,
  saturation = 1.0,
  brightness = 0.15,
}
-- make text brighter
local fg_dimmer = {
  hue = 1.0,
  saturation = 1.2,
  brightness = 1.5,
}
-- set background images on per-OS basis
if is_linux then
  bg_image = '/home/edothas/Pictures/1257089-3709430.jpg'
end
if is_windows then
  bg_image = 'C:\\Users\\mreed\\OneDrive - Mueller Water Products\\Pictures\\194427-outer-space-background-image.jpg'
end

if is_linux then
  config.default_prog = { '/usr/bin/bash' }
end
if is_windows then
  config.default_prog = { 'powershell.exe' }
end

--  Appearance
config.max_fps = 120
-- Configure the tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.tab_and_split_indices_are_zero_based = false
config.show_new_tab_button_in_tab_bar = true
config.unzoom_on_switch_pane = true
-- Tab padding
config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}
-- Fonts and colors for the tab bar
config.window_frame = {
  active_titlebar_bg = '#333333',
  inactive_titlebar_bg = '#333333',
}
if is_windows then
  config.window_frame = {
    font = wezterm.font { family = 'Ink Free' },
    font_size = 12.0,
  }
end
if is_linux then
  config.window_frame = {
    font = wezterm.font { family = 'FIX ME' },
    font_size = 12.0,
  }
end
config.colors = {
	tab_bar = {
		inactive_tab_edge = '#575757',
	},
}
--  and differentiate inactive panes
config.inactive_pane_hsb = {
	hue = 1,
  saturation = 0.9,
	brightness = 0.8,
}

--  font, background, and color scheme. I don't think color schemes have much effect on windows
if is_linux then
  config.font = wezterm.font_with_fallback {
    'Ubuntu Mono',
  }
end
if is_windows then
  config.font = wezterm.font_with_fallback {
	'Lucida Console',
	'Consolas',
	'Cascadia Code',
	'Symbol',
  }
end
config.color_scheme = 'Eldritch'
-- config.color_scheme = 'aikofog'
-- config.color_scheme = 'Alien Blood (Gogh)'
-- config.color_scheme = 'Dark Pastel (Gogh)'
-- config.color_scheme = 'darkmoss'
-- config.text_background_opacity = 0.2

config.enable_scroll_bar = true
config.min_scroll_bar_height = '2cell'
config.default_cursor_style = 'BlinkingBlock'
config.foreground_text_hsb = fg_dimmer
config.colors = {
  scrollbar_thumb = 'white',
}

config.background = {
{
    source = {
      File = bg_image,
    },
    repeat_x = 'NoRepeat',
    repeat_y = 'Mirror',
    hsb = bg_dimmer,
    width = '100%',
    attachment = { Parallax = 0.25 },
  }
}

  --  set the working environment
config.default_cwd = ""
if is_windows then
  config.launch_menu = {
    {
      label = 'Powershell',
      args = { 'powershell.exe', '-nologo' },
    },
    {
      label = 'WSL for Debian',
      args = { 'WSL:Debian' },
    },
    {
      label = 'WSL for Docker',
      args = { 'WSL:Docker-Desktop' },
    },
    {
      label = 'CMD',
      args = { 'cmd.exe' },
    }
  }
end
if is_linux then
  config.launch_menu = {
    {
      args = { 'top' },
    },
    {
      label = 'Bash',
      args = { '/usr/bin/bash' },
    }
  }
  config.initial_cols = 100
  config.initial_rows = 28
end
-- and finally, return the configuration to wezterm
return config
