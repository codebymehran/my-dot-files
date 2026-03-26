local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ============================================
-- THEME
-- ============================================
local DARK = "Tokyo Night"
local LIGHT = "Tokyo Night Day"

config.color_scheme = DARK

-- ============================================
-- FONT
-- ============================================
config.font = wezterm.font("MesloLGL Nerd Font Mono")
config.font_size = 19
config.line_height = 1.2

-- ============================================
-- WINDOW
-- ============================================
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = { left = 24, right = 24, top = 24, bottom = 16 }

config.window_background_opacity = 0.92
config.macos_window_background_blur = 20

config.initial_cols = 220
config.initial_rows = 50

-- ============================================
-- CURSOR
-- ============================================
config.default_cursor_style = "BlinkingBar"
config.cursor_thickness = "2px"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.animation_fps = 60

-- ============================================
-- INACTIVE PANE DIMMING
-- ============================================
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.6,
}

-- ============================================
-- SCROLLBACK
-- ============================================
config.scrollback_lines = 10000

-- ============================================
-- QUALITY OF LIFE
-- ============================================

-- ❌ Removed quit confirmation
config.window_close_confirmation = "NeverPrompt"

config.foreground_text_hsb = {
  brightness = 1.0,
  saturation = 1.0,
}

config.hyperlink_rules = wezterm.default_hyperlink_rules()

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "CursorColor",
}

-- ============================================
-- KEYBINDINGS
-- ============================================
config.keys = {

  -- Theme toggle
  { key = "T", mods = "CMD|SHIFT", action = wezterm.action.EmitEvent("toggle-theme") },

  -- Split panes
  { key = "d", mods = "CMD",       action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "D", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

  -- Navigate panes
  { key = "h", mods = "CMD|OPT",   action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "l", mods = "CMD|OPT",   action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "k", mods = "CMD|OPT",   action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "j", mods = "CMD|OPT",   action = wezterm.action.ActivatePaneDirection("Down") },

  -- Resize panes
  { key = "H", mods = "CMD|OPT",   action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
  { key = "L", mods = "CMD|OPT",   action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
  { key = "K", mods = "CMD|OPT",   action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
  { key = "J", mods = "CMD|OPT",   action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

  -- Close pane
  { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

  -- Font size
  { key = "=", mods = "CMD", action = wezterm.action.IncreaseFontSize },
  { key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
  { key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },
}

-- ============================================
-- THEME TOGGLE
-- ============================================
local is_dark = true

wezterm.on("toggle-theme", function(window)
  local overrides = window:get_config_overrides() or {}
  is_dark = not is_dark
  overrides.color_scheme = is_dark and DARK or LIGHT
  window:set_config_overrides(overrides)
end)

return config
