--[[
	MultiFlood
	Author : ddel641
	based on AutoFlood by LenweSaralonde
]]

-- ===========================================
-- Main code functions
-- ===========================================

local MAX_RATE = 10
local isFloodActive = false

--- Main script initialization
--
function MultiFlood_OnLoad()
	MultiFlood_Frame:RegisterEvent("VARIABLES_LOADED") -- Shows that the variables have loaded
	MultiFlood_Frame.timeSinceLastUpdate = 0 -- Sets the timer to 0
	MultiFlood_Frame:SetScript("OnEvent", MultiFlood_OnEvent) -- Calls MultiFlood_OnEvent when an event happens. 
	MultiFlood_Frame:SetScript("OnUpdate", MultiFlood_OnUpdate) -- when an update happens call MultiFlood_OnUpdate
end

--- Event handler function
--
---- This is runs when an event is recognized by the UI
function MultiFlood_OnEvent(self, event)
	-- Init saved variables
	if event == "VARIABLES_LOADED" then

		-- Add-on version
		local version = GetAddOnMetadata("MultiFlood", "Version") -- gets the addon version

		-- Init configuration
		---- Sets initial Values for the character
		MF_characterConfig = Mixin({
			message = "MultiFlood " .. version,
			channel = "say",
			rate = 60,
		}, MF_characterConfig or {})

		-- Display welcome message
		local s = string.gsub(MULTIFLOOD_LOAD, "VERSION", version)
		DEFAULT_CHAT_FRAME:AddMessage(s, 1, 1, 1)
	end
end

--- Enable flood!
--
function MultiFlood_On()
	isFloodActive = true
	MultiFlood_Info()
	MultiFlood_Frame.timeSinceLastUpdate = MF_characterConfig.rate
end

--- Stop flood
--
function MultiFlood_Off()
	DEFAULT_CHAT_FRAME:AddMessage(MULTIFLOOD_INACTIVE, 1, 0, 0)
	isFloodActive = false
end

--- Frame update handler
--
function MultiFlood_OnUpdate(self, elapsed)
	if not isFloodActive or MessageQueue.GetNumPendingMessages() > 0 then return end
	MultiFlood_Frame.timeSinceLastUpdate = MultiFlood_Frame.timeSinceLastUpdate + elapsed
	if MultiFlood_Frame.timeSinceLastUpdate > MF_characterConfig.rate then
		local system, channelNumber = MultiFlood_GetChannel(MF_characterConfig.channel)
		if system == nil then
			local s = string.gsub("[MultiFlood] " .. MULTIFLOOD_ERR_CHAN, "CHANNEL", MF_characterConfig.channel)
			DEFAULT_CHAT_FRAME:AddMessage(s, 1, 0, 0)
		else
			MessageQueue.SendChatMessage(MF_characterConfig.message, system, nil, channelNumber)
		end
		MultiFlood_Frame.timeSinceLastUpdate = 0
	end
end

--- Show parameters
--
function MultiFlood_Info()
	if isFloodActive then
		DEFAULT_CHAT_FRAME:AddMessage(MULTIFLOOD_ACTIVE, 0, 1, 0)
	else
		DEFAULT_CHAT_FRAME:AddMessage(MULTIFLOOD_INACTIVE, 1, 1, 1)
	end

	local s = MULTIFLOOD_STATS
	s = string.gsub(s, "MESSAGE", MF_characterConfig.message)
	s = string.gsub(s, "CHANNEL", MF_characterConfig.channel)
	s = string.gsub(s, "RATE", MF_characterConfig.rate)
	DEFAULT_CHAT_FRAME:AddMessage(s, 1, 1, 1)
end

--- Set the message to send.
-- @param msg (string)
function MultiFlood_SetMessage(index, msg)
	if msg ~= "" then
		MF_characterConfig.message = msg
	end
	local s = string.gsub(MULTIFLOOD_MESSAGE, "MESSAGE", MF_characterConfig.message)
	DEFAULT_CHAT_FRAME:AddMessage(s, 1, 1, 1)
end

--- Set the amount of seconds between each message sending.
-- @param rate (number)
function MultiFlood_SetRate(rate)
	if rate ~= nil and tonumber(rate) > 0 and rate ~= "" then rate = tonumber(rate) end
	if rate >= MAX_RATE then
		MF_characterConfig.rate = rate
		local s = string.gsub(MULTIFLOOD_RATE, "RATE", MF_characterConfig.rate)
		DEFAULT_CHAT_FRAME:AddMessage(s, 1, 1, 1)
	else
		local s = string.gsub(MULTIFLOOD_ERR_RATE, "RATE", MAX_RATE)
		DEFAULT_CHAT_FRAME:AddMessage(s, 1, 0, 0)
	end
end

--- Return channel system and number
-- @param channel (string) Channel name, as prefixed by the slash.
-- @return system (string|nil)
-- @return channelNumber (int|nil)
-- @return channelName (string|nil)
function MultiFlood_GetChannel(channel)
	local ch = strlower(strtrim(channel))
	if ch == "say" or ch == "s" then
		return "SAY", nil, ch
	elseif ch == "guild" or ch == "g" then
		return "GUILD", nil, ch
	elseif ch == "raid" or ch == "ra" then
		return "RAID", nil, ch
	elseif ch == "party" or ch == "p" or ch == "gr" then
		return "PARTY", nil, ch
	elseif ch == "i" then
		return "INSTANCE_CHAT", nil, ch
	elseif ch == "bg" then
		return "BATTLEGROUND", nil, ch
	elseif GetChannelName(channel) ~= 0 then
		return "CHANNEL", (GetChannelName(channel)), channel
	end
	return nil, nil, nil
end

--- Set the event / system / channel type according fo the game channel /channel.
-- @param channel (string) Channel name, as prefixed by the slash.
function MultiFlood_SetChannel(channel)
	local system, _, channelName = MULTIFLOOD_GetChannel(channel)
	if system == nil then
		-- Bad channel
		local s = string.gsub(MULTIFLOOD_ERR_CHAN, "CHANNEL", channel)
		DEFAULT_CHAT_FRAME:AddMessage(s, 1, 0, 0)
	else
		-- Save channel setting
		MF_characterConfig.channel = channelName
		local s = string.gsub(MULTIFLOOD_CHANNEL, "CHANNEL", channelName)
		DEFAULT_CHAT_FRAME:AddMessage(s, 1, 1, 1)
	end
end

-- ===========================================
-- Slash command aliases
-- ===========================================

--- /flood [on|off]
-- Start / stop flood
-- @param s (string)
SlashCmdList["MultiFlood"] = function(s)
	if s == "on" then
		MultiFlood_On()
	elseif s == "off" then
		MultiFlood_Off()
	else
		if isFloodActive then
			MultiFlood_Off()
		else
			MultiFlood_On()
		end
	end
end

-- /floodmessage <message>
-- Set the message to send
SlashCmdList["MULTIFLOODSETMESSAGE"] = MultiFlood_SetMessage

-- /floodchan <channel>
-- Set the channel
SlashCmdList["MULTIFLOODSETCHANNEL"] = MultiFlood_SetChannel

-- /floodrate <duration>
-- Set the period (in seconds)
SlashCmdList["MULTIFLOODSETRATE"] = MultiFlood_SetRate

-- /floodinfo
-- Display the parameters in chat window
SlashCmdList["MULTIFLOODINFO"] = MultiFlood_Info

-- /floodhelp
-- Display help in chat window
SlashCmdList["MultiFloodHELP"] = function()
	for _, l in pairs(MULTIFLOOD_HELP) do
		DEFAULT_CHAT_FRAME:AddMessage(l, 1, 1, 1)
	end
end

-- Command aliases
SLASH_MULTIFLOOD1 = "/mflood"

SLASH_MULTIFLOODSETMESSAGE1 = "/mfloodmessage"
SLASH_MULTIFLOODSETMESSAGE2 = "/mfloodmsg"

SLASH_MULTIFLOODSETCHANNEL1 = "/mfloodchannel"
SLASH_MULTIFLOODSETCHANNEL2 = "/mfloodchan"

SLASH_MULTIFLOODSETRATE1 = "/mfloodrate"

SLASH_MULTIFLOODINFO1 = "/mfloodinfo"
SLASH_MULTIFLOODINFO2 = "/mfloodconfig"

SLASH_MULTIFLOODHELP1 = "/mfloodhelp"
SLASH_MULTIFLOODHELP2 = "/mfloodman"
