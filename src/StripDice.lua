STRIPDICE_SLUG = "StripDice"
STRIPDICE_MSG_VERSION = GetAddOnMetadata( STRIPDICE_SLUG, "Version" )
STRIPDICE_MSG_ADDONNAME = GetAddOnMetadata( STRIPDICE_SLUG, "Title" )
STRIPDICE_MSG_AUTHOR = GetAddOnMetadata( STRIPDICE_SLUG, "Author" )

-- Colours
COLOR_RED = "|cffff0000";
COLOR_GREEN = "|cff00ff00";
COLOR_BLUE = "|cff0000ff";
COLOR_PURPLE = "|cff700090";
COLOR_YELLOW = "|cffffff00";
COLOR_ORANGE = "|cffff6d00";
COLOR_GREY = "|cff808080";
COLOR_GOLD = "|cffcfb52b";
COLOR_NEON_BLUE = "|cff4d4dff";
COLOR_END = "|r";

StripDice = {}
StripDice_games = {}
--	[ts] = {    -- for a game
--		[player] = roll,
--	}
StripDice.currentGame = nil   -- probably don't need to do this

StripDice_options = { ["lowIcon"] = 1, ["highIcon"] = 7 }  -- defaults.  Change this structure....

StripDice.raidIconValues = {  -- will be used later to allow control
	["none"] = 0,
	["star"] = 1,
	["circle"] = 2,
	["diamond"] = 3,
	["triangle"] = 4,
	["moon"] = 5,
	["square"] = 6,
	["cross"] = 7,
	["skull"] = 8,
}
function StripDice.Print( msg, showName )
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	if (showName == nil) or (showName) then
		msg = COLOR_NEON_BLUE.."StripDice> "..COLOR_END..msg
	end
	DEFAULT_CHAT_FRAME:AddMessage( msg )
end
function StripDice.OnLoad()
	--StripDiceFrame:RegisterEvent( "VARIABLES_LOADED" )
	StripDiceFrame:RegisterEvent( "GROUP_ROSTER_UPDATE" )
	StripDiceFrame:RegisterEvent( "PLAYER_ENTERING_WORLD" )
	--StripDice.myName = UnitName( "player" )
end
function StripDice.GROUP_ROSTER_UPDATE()
	local NumGroupMembers = GetNumGroupMembers()
	--StripDice.Print( "There are now "..NumGroupMembers.." in your group." )
	if( NumGroupMembers == 0 ) then  -- turn off listening
		StripDice.Print( "Deactivating Dice game." )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_SYSTEM" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_SAY" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_PARTY" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_PARTY_LEADER" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_RAID" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_RAID_LEADER" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_INSTANCE_CHAT" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_INSTANCE_CHAT_LEADER" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_YELL" )
		StripDice.StopGame()
		StripDice.gameActive = nil
	elseif( NumGroupMembers > 0 and not StripDice.gameActive ) then
		StripDice.Print( "Dice game is active." )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_SYSTEM" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_SAY" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_PARTY" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_PARTY_LEADER" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_RAID" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_RAID_LEADER" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_INSTANCE_CHAT" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_INSTANCE_CHAT_LEADER" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_YELL" )
		StripDice.gameActive = true
	end
end
StripDice.PLAYER_ENTERING_WORLD = StripDice.GROUP_ROSTER_UPDATE
function StripDice.CHAT_MSG_SAY( ... )
	_, msg, language, _, _, other = ...
	msg = string.lower( msg )
	if( string.find( msg, "set" ) ) then  -- set is the key word here
		--print( msg )
		local hl = string.match( msg, "(low)" ) or string.match( msg, "(high)" )
		if( hl ) then
			local variableName = hl.."Icon"
			local icon = 0
			for iconName, iconValue in pairs( StripDice.raidIconValues ) do
				if( string.match( msg, iconName ) ) then
					---print( "Set "..variableName.." to "..icon )
					StripDice_options[variableName] = ( iconValue > 0 and iconValue or nil )
					for n,v in pairs( StripDice_options ) do
						if( n ~= variableName and v == iconValue ) then
							StripDice_options[n] = nil
						end
					end
				end
			end
		end
	elseif( string.find( msg, "roll" ) ) then  -- roll starts a roll
		--StripDice.Print( "msg:"..msg )
		StripDice.StopGame()
		StripDice.currentGame = time()
		StripDice_games[ StripDice.currentGame ] = {}
		StripDice.Print( "A roll has been started.  Game: "..StripDice.currentGame )

		local pruneCount = 0
		for gameTS in pairs( StripDice_games ) do
			if( gameTS + 86400 < StripDice.currentGame ) then
				StripDice_games[gameTS] = nil
				pruneCount = pruneCount + 1
			end
		end
		if( pruneCount > 0 ) then
			StripDice.Print( "Pruned "..pruneCount.." old games." )
		end
	elseif( StripDice.currentGame and StripDice.currentGame + 60 < time() ) then  -- game is started, and older than 1 minute
		StripDice.Print( "Game timed out" )
		StripDice.StopGame()
	end
end
StripDice.CHAT_MSG_PARTY = StripDice.CHAT_MSG_SAY
StripDice.CHAT_MSG_PARTY_LEADER = StripDice.CHAT_MSG_SAY
StripDice.CHAT_MSG_RAID = StripDice.CHAT_MSG_SAY
StripDice.CHAT_MSG_RAID_LEADER = StripDice.CHAT_MSG_SAY
StripDice.CHAT_MSG_INSTANCE_CHAT = StripDice.CHAT_MSG_SAY
StripDice.CHAT_MSG_INSTANCE_CHAT_LEADER = StripDice.CHAT_MSG_SAY
StripDice.CHAT_MSG_YELL = StripDice.CHAT_MSG_SAY

function StripDice.CHAT_MSG_SYSTEM( ... )
	_, roll = ...
	--StripDice.Print( roll )
	local found, _, who, roll, low, high = string.find( roll, "(.+) rolls (%d+) %((%d+)%-(%d+)%)")
	if( found ) then
		roll = tonumber( roll )
		low = tonumber( low )
		high = tonumber( high )
		--StripDice.Print( who.." rolled a "..roll.." in the range of ("..low.." - "..high..")" )
		if( StripDice.currentGame and StripDice.currentGame + 60 >= time() ) then
			if( StripDice_games[StripDice.currentGame][who] ) then
				DoEmote( "No", who )
				StripDice.Print( who.." has already rolled." )
			else
				StripDice_games[StripDice.currentGame][who] = roll
			end
			for who,rolled in pairs( StripDice_games[StripDice.currentGame] ) do
				--StripDice.Print( who.." -> ".. rolled )
				StripDice.min = min( rolled, StripDice.min or high )
				StripDice.max = max( rolled, StripDice.max or low )
				--StripDice.Print( "min -> "..StripDice.min )

				if( rolled == StripDice.min ) then StripDice.minWho = who end
				if( rolled == StripDice.max ) then StripDice.maxWho = who end
			end
			--StripDice.Print( "Set min on "..StripDice.minWho )
			if( StripDice_options.lowIcon ) then SetRaidTarget( StripDice.minWho, StripDice_options.lowIcon ) end
			if( StripDice_options.highIcon ) then SetRaidTarget( StripDice.maxWho, StripDice_options.highIcon ) end
		end
	end
end
function StripDice.StopGame()
	StripDice.currentGame = nil
	if( StripDice.minWho ) then SetRaidTarget( StripDice.minWho, 0 ) end
	StripDice.min = nil
	StripDice.minWho = nil
	if( StripDice.maxWho ) then SetRaidTarget( StripDice.maxWho, 0 ) end
	StripDice.max = nil
	StripDice.maxWho = nil
end
