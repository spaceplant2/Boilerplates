-- Universal config file
-- see https://github.com/wez/wezterm/discussions/4728 for hints on OS detection

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Check OS
-- https://github.com/wez/wezterm/discussions/4728
local is_darwin <const> = wezterm.target_triple:find("darwin") ~= nil
local is_linux <const> = wezterm.target_triple:find("linux") ~= nil
local is_windows <const> = wezterm.target_triple:find("windows") ~= nil

if is_linux then
  config.default_prog = { '/usr/bin/bash' }
end
if is_windows then
  config.default_prog = { 'powershell.exe' }
end

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

config.window_frame = {
-- The font used in the tab bar.
-- Whatever font is selected here, it will have the main font setting appended to it to pick up any
-- fallback fonts you may have used there.
  font = wezterm.font_with_fallback { 
-- Linux fonts
    'eufm10',
    'Chilanka',
-- Windows fonts
    'Ink Free'
  },
  font_size = 12.0,
-- The overall background color of the tab bar when the window is focused
  active_titlebar_bg = '#553333',
-- The overall background color of the tab bar when the window is not focused
  inactive_titlebar_bg = '#553333',
}
config.colors = {
	tab_bar = {
-- The color of the inactive tab bar edge/divider
		inactive_tab_edge = '#575757',
	},
}
--  differentiate inactive panes
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}
--  font, background, and color scheme

config.font = wezterm.font_with_fallback {
-- linux fonts
  'Ubuntu Mono',
-- windows fonts
	'Lucida Console',
	'Consolas',
	'Cascadia Code',
	'Symbol',
}
-- config.color_scheme = 'Alien Blood (Gogh)'
config.color_scheme = 'aikofog'
-- config.color_scheme = 'Dark Pastel (Gogh)'
-- config.color_scheme = 'darkmoss'
config.text_background_opacity = 0.2
--  static background image --
-- config.window_background_image = '/home/edothas/Pictures/aurora-1938348.jpg'
-- config.window_background_image_hsb = {
-- 	brightness = 0.1,
-- 	hue = 1.0,
-- 	saturation = 1.0,
-- }

--  A more complex background that scrolls
local dimmer = {
  brightness = 0.1,
  hue = 1.0,
  saturation = 1.0,
}

config.enable_scroll_bar = true
config.min_scroll_bar_height = '2cell'
config.colors = {
  scrollbar_thumb = 'white',
}
config.background = {
  -- This is the deepest/back-most layer. It will be rendered first
  {
    source = {
      File = '/home/edothas/Pictures/1257089-3709430.jpg',
    },
    -- The texture tiles vertically but not horizontally.
    -- When we repeat it, mirror it so that it appears "more seamless".
    -- An alternative to this is to set `width = "100%"` and have
    -- it stretch across the display
    repeat_x = 'Mirror',
    hsb = dimmer,
    -- When the viewport scrolls, move this layer 10% of the number of
    -- pixels moved by the main viewport. This makes it appear to be
    -- further behind the text.
    attachment = { Parallax = 0.1 },
    width = '100%',
    repeat_y_size = '100%',
  }
}
-- 
--  set the working environment
config.default_cwd = ""
config.launch_menu = {
	{
		args = { 'top' },
	},
	{
		label = 'Powershell',
		args = { 'powershell.exe', '-nologo' },
	},
	{
		label = 'CMD',
		args = { 'cmd.exe' },
	}
}
-- and finally, return the configuration to wezterm
return config
