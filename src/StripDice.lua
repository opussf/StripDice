STRIPDICE_SLUG = "StripDice"
STRIPDICE_MSG_VERSION = GetAddOnMetadata( STRIPDICE_SLUG, "Version" )
STRIPDICE_MSG_ADDONNAME = GetAddOnMetadata( STRIPDICE_SLUG, "Title" )
STRIPDICE_MSG_AUTHOR = GetAddOnMetadata( STRIPDICE_SLUG, "Author" )

-- Colours
COLOR_NEON_BLUE = "|cff4d4dff";
COLOR_END = "|r";

StripDice = {}
StripDice_games = {}
--	[ts] = {    -- for a game
--		[player] = roll,
--	}
StripDice_log = {}
StripDice.currentGame = nil   -- probably don't need to do this

StripDice_options = { ["lowIcon"] = {1}, ["highIcon"] = {7} }  -- defaults.  Change this structure....

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
function StripDice.LogMsg( msg, alsoPrint )
	-- alsoPrint, if set to true, prints to console
	table.insert( StripDice_log, { [time()] = msg } )
	if( alsoPrint ) then StripDice.Print( msg ); end
end
function StripDice.OnLoad()
	--StripDiceFrame:RegisterEvent( "VARIABLES_LOADED" )
	StripDiceFrame:RegisterEvent( "GROUP_ROSTER_UPDATE" )
	StripDiceFrame:RegisterEvent( "PLAYER_ENTERING_WORLD" )
	StripDiceFrame:RegisterEvent( "VARIABLES_LOADED" )
	--StripDice.myName = UnitName( "player" )
end
function StripDice.VARIABLES_LOADED()
	StripDiceFrame:UnregisterEvent( "VARIABLES_LOADED" )
	StripDice_log = {}
end
function StripDice.GROUP_ROSTER_UPDATE()
	local NumGroupMembers = GetNumGroupMembers()
	StripDice.LogMsg( "There are now "..NumGroupMembers.." in your group." )
	if( NumGroupMembers == 0 ) then  -- turn off listening
		StripDice.LogMsg( "Deactivating Dice game.", true )
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
		StripDice.LogMsg( "Dice game is active.", true )
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
			--print( "msg: "..msg )
			local index = 0
			for testString in string.gmatch( msg, "%S+" ) do
				--print( "testString: "..testString )
				for iconName, iconValue in pairs( StripDice.raidIconValues ) do
					if( string.match( testString, iconName ) ) then
						if( index == 0 ) then StripDice_options[variableName] = {}; end
						index = index + 1
						StripDice_options[variableName][index] = ( iconValue > 0 and iconValue or nil )
						-- search for this icon elsewhere and clear it.
						for setting, settingTable in pairs( StripDice_options ) do
							for i, val in pairs( settingTable ) do
								--print( "value: "..val.." =? "..iconValue.."  index: "..i.." =? "..index.."  setting: "..setting.." =? "..variableName )
								if( val == iconValue and ( i ~= index or setting ~= variableName ) ) then
									--print( "setting "..setting.."["..i.."] to nil" )
									StripDice_options[setting][i] = nil
								end
							end
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
		StripDice.LogMsg( "A roll has been started.  Game: "..StripDice.currentGame )

		local pruneCount = 0
		for gameTS in pairs( StripDice_games ) do
			if( gameTS + 604800 < StripDice.currentGame ) then
				StripDice_games[gameTS] = nil
				pruneCount = pruneCount + 1
			end
		end
		if( pruneCount > 0 ) then
			StripDice.LogMsg( "Pruned "..pruneCount.." old games.", true )
		end
	elseif( StripDice.currentGame and StripDice.currentGame + 60 < time() ) then  -- game is started, and older than 1 minute
		StripDice.LogMsg( "Game timed out", true)
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
			-- build sorted rolls table
			local rolls = {}
			for _,rolled in pairs( StripDice_games[StripDice.currentGame] ) do
				table.insert( rolls, rolled )
			end
			table.sort( rolls )

			-- build min and max from rolls
			StripDice.min = {}
			StripDice.max = {}
			local numRolls = #rolls
			for i = 1, numRolls do
				--print( i..": "..rolls[i] )
				table.insert( StripDice.min, rolls[i] )
				table.insert( StripDice.max, rolls[numRolls - (i-1)] )
			end

			local numHigh = #StripDice_options.highIcon
			local numLow = #StripDice_options.lowIcon

			--print( "I have "..#rolls.." rolls." )
			--print( "I need "..numHigh.." high rolls, and "..numLow.." low rolls ("..( numHigh + numLow )..")" )

			-- find how many of what I need.
			while( #rolls < ( numHigh + numLow ) ) do
				if( numHigh > numLow ) then
					--print( "High - 1" )
					numHigh = numHigh - 1
				elseif( numLow > numHigh ) then
					numLow = numLow - 1
					--print( "Low - 1" )
				else
					--print( "Both - 1" )
					numLow = numLow - 1
					numHigh = numHigh - 1
				end
			end
			-- reset to at least 1
			if( numHigh == 0 and #StripDice_options.highIcon >= 1 ) then numHigh = 1; end
			if( numLow  == 0 and #StripDice_options.lowIcon >= 1 ) then numLow  = 1; end

			numHigh = math.min( numHigh, #StripDice_options.highIcon )
			numLow = math.min( numLow, #StripDice_options.lowIcon )

			print( "I need "..numHigh.." high rolls, and "..numLow.." low rolls ("..( numHigh + numLow )..")" )
			print( "high icon count: "..#StripDice_options.highIcon.."   low icon count: "..#StripDice_options.lowIcon )

			-- find who has the top n rolls
			--print( "Find Max" )
			StripDice.maxWho = {}
			local who = {}
			for rollIndex = 1, numHigh do
				rollValue = StripDice.max[rollIndex]
				for name, roll in pairs( StripDice_games[StripDice.currentGame] ) do
					if( roll == rollValue and who[name] == nil ) then
						who[name] = roll
						table.insert( StripDice.maxWho, name )
					end
				end
				--print( "rollIndex: "..rollIndex.." rollValue: "..rollValue )
			end

			--print( "Find Min" )
			StripDice.minWho = {}
			who = {}
			for rollIndex = 1, numLow do
				rollValue = StripDice.min[rollIndex]
				for name, roll in pairs( StripDice_games[StripDice.currentGame] ) do
					if( roll == rollValue and who[name] == nil ) then
						who[name] = roll
						table.insert( StripDice.minWho, name )
					end
				end
				--print( "rollIndex: "..rollIndex.." rollValue: "..rollValue )
			end
			for i,name in ipairs( StripDice.minWho ) do
				--print( "Min: Put "..StripDice_options.lowIcon[i].." on "..name )
				SetRaidTarget( name, ( StripDice_options.lowIcon[i] or 0 ) )
			end
			for i,name in ipairs( StripDice.maxWho ) do
				--print( "Max: Put "..StripDice_options.highIcon[i].." on "..name )
				SetRaidTarget( name, ( StripDice_options.highIcon[i] or 0 ) )
			end
		end
	end
end
function StripDice.StopGame()
	-- @TODO  'fix this too'
	StripDice.currentGame = nil
	if( StripDice.minWho ) then
		for _,name in pairs( StripDice.minWho ) do
			SetRaidTarget( name, 0 )
		end
	end
	StripDice.min = nil
	StripDice.minWho = nil
	if( StripDice.maxWho ) then
		for _,name in pairs( StripDice.maxWho ) do
			SetRaidTarget( name, 0 )
		end
	end
	StripDice.max = nil
	StripDice.maxWho = nil
end
