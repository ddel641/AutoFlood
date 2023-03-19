max_line_length = false

exclude_files = {
}

ignore = {
	-- Ignore global writes/accesses/mutations on anything prefixed with the add-on name.
	-- This is the standard prefix for all of our global frame names and mixins.
	"11./^MultiFlood", -- Main functions
	"11./^MULTIFLOOD_", -- Localization strings

	-- Ignore unused self. This would popup for Mixins and Objects
	"212/self",
}

globals = {
	-- Saved variables
	"AF_characterConfig",

	-- Globals
	"SLASH_MULTIFLOOD1",
	"SLASH_MULTIFLOODSETMESSAGE1",
	"SLASH_MULTIFLOODSETMESSAGE2",
	"SLASH_MULTIFLOODSETCHANNEL1",
	"SLASH_MULTIFLOODSETCHANNEL2",
	"SLASH_MULTIFLOODSETRATE1",
	"SLASH_MULTIFLOODINFO1",
	"SLASH_MULTIFLOODINFO2",
	"SLASH_MULTIFLOODHELP1",
	"SLASH_MULTIFLOODHELP2",

	-- AddOn Overrides
}

read_globals = {
	-- Libraries

	-- 3rd party add-ons
	"MessageQueue"
}

std = "lua51+wow"

stds.wow = {
	-- Globals that we mutate.
	globals = {
		"SlashCmdList"
	},

	-- Globals that we access.
	read_globals = {
		-- Lua function aliases and extensions
		"date",
		"floor",
		"ceil",
		"format",
		"sort",
		"strconcat",
		"strjoin",
		"strlen",
		"strlenutf8",
		"strsplit",
		"strtrim",
		"strupper",
		"strlower",
		"tAppendAll",
		"tContains",
		"tFilter",
		"time",
		"tinsert",
		"tInvert",
		"tremove",
		"wipe",
		"max",
		"min",
		"abs",
		"random",
		"Lerp",
		"sin",
		"cos",

		-- Global Functions
		"GetLocale",
		"GetAddOnMetadata",
		"GetRealmName",
		"UnitName",
		"GetChannelName",
		"Mixin",

		-- Global Mixins and UI Objects
		"DEFAULT_CHAT_FRAME",

		-- Global Constants
	},
}
