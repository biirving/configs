local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- ==========================================================================
-- 1. FORCE THE RENDERER
-- ==========================================================================
config.front_end = "OpenGL"

-- ==========================================================================
-- 2. TRANSPARENCY SETTINGS
-- ==========================================================================
config.window_background_opacity = 0.7
config.macos_window_background_blur = 0

-- ==========================================================================
-- 3. APPEARANCE OVERRIDES
-- ==========================================================================
config.color_scheme = 'Catppuccin Mocha'
-- config.color_scheme = 'Dracula'
config.window_decorations = "RESIZE"
config.window_background_image = ""
config.adjust_window_size_when_changing_font_size = false

-- ==========================================================================
-- 4. TAB BAR & EXTRA LARGE TABS
-- ==========================================================================
-- Fancy tab bar is REQUIRED for window_frame.font_size to control tab height.
-- (With use_fancy_tab_bar = false, the retro bar is locked to one cell tall.)
config.use_fancy_tab_bar = true

-- 1) The frame font_size drives the physical tab height in fancy mode.
config.window_frame = {
  font = wezterm.font({ family = 'JetBrains Mono', weight = 'Bold' }),
  font_size = 15.0, -- Increase this number to make tabs taller.
  -- Match the bar background to Catppuccin Mocha base:
  active_titlebar_bg = "#1e1e2e",
  inactive_titlebar_bg = "#1e1e2e",
}

-- 2) Tab block colors (these still apply in fancy mode).
config.colors = {
  tab_bar = {
    background = "#1e1e2e", -- Match Catppuccin Mocha base background
    active_tab = {
      bg_color = "#89b4fa", -- Vibrant blue for active tab block
      fg_color = "#11111b",
    },
    inactive_tab = {
      bg_color = "#11111b", -- Dark block for unselected tabs
      fg_color = "#a6adc8",
    },
    inactive_tab_hover = {
      bg_color = "#313244",
      fg_color = "#cdd6f4",
    },
  },
}

-- 3) Generous horizontal spacing inside each tab block.
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  -- Use the manually-set tab title if there is one; otherwise fall back
  -- to the active pane's title.
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end

  return {
    { Attribute = { Intensity = 'Bold' } },
    { Text = "       " .. title .. "       " },
  }
end)


-- ==========================================================================
-- 5. KEYBINDINGS
-- ==========================================================================
config.keys = {
  -- Interactive tab renaming
  {
    key = 'r',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  -- Tab navigation
  { key = 'Tab', mods = 'SHIFT', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL',  action = wezterm.action.ActivateTabRelative(-1) },
  -- Horizontal Split (ALT + SHIFT + |)
  {
    key = '|',
    mods = 'ALT|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  -- Vertical Split (ALT + SHIFT + _)
  {
    key = '_',
    mods = 'ALT|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  -- Move between panes (Shift + Arrows)
  { key = 'LeftArrow',  mods = 'SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
}

return config
