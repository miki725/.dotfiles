local wezterm = require("wezterm")

return {
	automatically_reload_config = true,
	hide_tab_bar_if_only_one_tab = true,
	native_macos_fullscreen_mode = true,

	default_prog = {
		"/bin/sh",
		os.getenv("HOME") .. "/.bin/exec_first_found.sh",
		"tmux",
		"fish --login",
		"bash --login",
		"zsh --login",
	},

	scrollback_lines = 100000,
	initial_rows = 40,
	initial_cols = 120,

	font = wezterm.font_with_fallback({ "Hack Nerd Font", "Menlo" }),
	font_size = 14,
	bold_brightens_ansi_colors = false,
	adjust_window_size_when_changing_font_size = false,
	warn_about_missing_glyphs = false,
	font_rules = {
		{
			italic = true,
			font = wezterm.font_with_fallback({ "Hack Nerd Font", "Menlo" }, { italic = true }),
		},
		{
			italic = true,
			intensity = "Bold",
			font = wezterm.font_with_fallback({ "Hack Nerd Font", "Menlo" }, { bold = true, italic = true }),
		},
		{
			intensity = "Bold",
			font = wezterm.font_with_fallback({ "Hack Nerd Font", "Menlo" }, { bold = true }),
		},
	},

	colors = {
		background = "#26282a",
		foreground = "#f0f0f0",

		cursor_bg = "#f8f8f0",
		cursor_fg = "#272822",
		cursor_border = "#b4fb75",

		selection_bg = "#FFD73F",
		selection_fg = "#263137",

		scrollbar_thumb = "#222222",

		split = "#444444",

		ansi = {
			"#26282a", -- black
			"#ff8878", -- red
			"#b4fb73", -- green
			"#fffcb7", -- yellow
			"#8bbce5", -- blue
			"#ffb2fe", -- magenta
			"#a2e1f8", -- cyan
			"#f1f1f1", -- white
		},
		brights = {
			"#6f6f6f", -- black
			"#fe978b", -- red
			"#d6fcba", -- green
			"#fffed5", -- yellow
			"#c2e3ff", -- blue
			"#ffc6ff", -- magenta
			"#c0e9f8", -- cyan
			"#ffffff", -- white
		},
	},

	-- https://wezfurlong.org/wezterm/config/keys.html
	disable_default_key_bindings = true,
	keys = {
		{ mods = "CMD", key = "c", action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }) },
		{ mods = "CMD", key = "v", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{ mods = "CMD", key = "h", action = "HideApplication" },
		{ mods = "CMD", key = "m", action = "Hide" },
		{ mods = "CMD", key = "n", action = "SpawnWindow" },

		{ mods = "CMD", key = "t", action = wezterm.action({ SpawnTab = "DefaultDomain" }) },
		{ mods = "CMD", key = "w", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ mods = "CMD|ALT", key = "LeftArrow", action = wezterm.action({ ActivateTabRelative = -1 }) },
		{ mods = "CMD|ALT", key = "RightArrow", action = wezterm.action({ ActivateTabRelative = 1 }) },

		{ mods = "CMD", key = "-", action = "DecreaseFontSize" },
		{ mods = "CMD", key = "=", action = "IncreaseFontSize" },
		{ mods = "CMD", key = "0", action = "ResetFontSize" },

		{ mods = "CMD", key = "Enter", action = "ToggleFullScreen" },
	},

	window_padding = {
		left = "0cell",
		right = "0cell",
		top = "0cell",
		bottom = "0cell",
	},
}
