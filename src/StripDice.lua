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
StripDice_players = {}

StripDice_options = { ["lowIcon"] = 1, ["highIcon"] = 7 }

StripDice.raidIconValues = {
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
function StripDice.GetNameFromIndex( index )
	StripDice.lookupPre = StripDice.lookupPre or "PARTY"
	if index > 4 then
		StripDice.lookupPre = "RAID"
	end
	local lookupString = StripDice.lookupPre..index
	return GetUnitName( lookupString ) or "NotSet"
end

function StripDice.OnLoad()
	StripDiceFrame:RegisterEvent( "VARIABLES_LOADED" )
	StripDiceFrame:RegisterEvent( "GROUP_ROSTER_UPDATE" )
	StripDiceFrame:RegisterEvent( "PLAYER_ENTERING_WORLD" )
	StripDice.myName = UnitName( "player" )
end
function StripDice.VARIABLES_LOADED()
	StripDiceFrame:UnregisterEvent( "VARIABLES_LOADED" )
end

function StripDice.GROUP_ROSTER_UPDATE()
	local NumGroupMembers = GetNumGroupMembers()
	StripDice.Print( "There are now "..NumGroupMembers.." in your group." )
	if( NumGroupMembers == 0 ) then
		StripDice.Print( "Resetting and clearing player listing." )
		StripDice_players = {}
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_SYSTEM" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_SAY" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_PARTY" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_PARTY_LEADER" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_RAID" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_RAID_LEADER" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_INSTANCE_CHAT" )
		StripDiceFrame:UnregisterEvent( "CHAT_MSG_INSTANCE_CHAT_LEADER" )

		StripDiceFrame:UnregisterEvent( "CHAT_MSG_YELL" )
	elseif( NumGroupMembers > 0 ) then
		StripDiceFrame:RegisterEvent( "CHAT_MSG_SYSTEM" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_SAY" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_PARTY" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_PARTY_LEADER" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_RAID" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_RAID_LEADER" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_INSTANCE_CHAT" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_INSTANCE_CHAT_LEADER" )
		StripDiceFrame:RegisterEvent( "CHAT_MSG_YELL" )
		StripDice_players[ StripDice.myName ] = {}
		for i = 1, GetNumGroupMembers() do
			local name = StripDice.GetNameFromIndex( i )
			StripDice_players[name] = StripDice_players[name] or {}
		end
	end
end
StripDice.PLAYER_ENTERING_WORLD = StripDice.GROUP_ROSTER_UPDATE
function StripDice.CHAT_MSG_SAY( ... )
	_, msg, language, _, _, other = ...
	StripDice.Print( "msg:"..msg )
	msg = string.lower( msg )
	if( string.find( msg, "roll" ) ) then
		StripDice.Print( "A roll has been started." )
		StripDice.Print( "other: "..other.." language: "..language )
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
	StripDice.Print( roll )
	found, _, who, roll, low, high = string.find( roll, "(.+) rolls (%d+) %((%d+)%-(%d+)%)")
	if( found ) then
		StripDice.Print( who.." rolled a "..roll.." in the range of ("..low.." - "..high..")" )

		--SetRaidTarget(Vic.srcName, Vic.raidIconValues[Vic_options.symbol]);
	end
end
---------




--[[


	-- code for when party members are changed
	--
	Didit.Debug( "GROUP_ROSTER_UPDATE" )
	-- scan the players
	Screenshot()

	for i = 1, GetNumGroupMembers() do
		local lookupString = Didit.lookupPre..i
		local unitName = GetUnitName( lookupString ) or "NotSet"
		Didit.Debug( ("unitName: %s"):format( unitName or "Not Set" ) )
		if not Didit_players[unitName] then
			Didit_players[unitName] = {}
			Didit.Print( ("init player: %s"):format( unitName ) )
		end
		if Didit.statisticID and not Didit_players[unitName][Didit.statisticID] then
			Didit.Print( ("  I haz a statisticID(%s) and need to init %s"):format( Didit.statisticID, unitName ) )
			Didit_players[unitName][Didit.statisticID] = { Started = "Yes" }
		end
	end
	if not Didit_players[Didit.myName] then
		Didit_players[Didit.myName] = {}
	end
]]

--[[


function Vic.OnLoad()
	VicFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	VicFrame:RegisterEvent("VARIABLES_LOADED");

	SLASH_VIC1 = "/vic";
	SlashCmdList["VIC"] = Vic.Command;
end

function Vic.OptionsOnLoad(frame)
	local ristring = '|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:0:0:0:-1|t %s'

	frame.name = "Victorious Reporter";
	VicOptionsFrame_Title:SetText("Victorious Reporter "..VIC_MSG_VERSION);
	for symbol, v in pairs(Vic.raidIconValues) do
		getglobal("VicOptionsFrame_RadioSymbol"..v.."Text"):SetText(ristring:format(v, symbol));
	end
	frame.okay = Vic.OptionsOkay;
	frame.cancel = Vic.OptionsCancel;

	InterfaceOptions_AddCategory(frame);
end

function Vic.PartyPrint( msg )
	-- prints to Party
	-- 1.19 - update to output to guild, raid / party or none.
	if (GetNumRaidMembers() > 0) then
		SendChatMessage( msg, "RAID" );
	elseif (GetNumPartyMembers() > 0) then
		SendChatMessage( msg, "PARTY" );
	else
		Vic.Print( COLOR_RED.."Vic_ToParty: "..COLOR_END..msg, false );
	end
end

function Vic.Print( msg, showName)
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	if (showName == nil) or (showName) then
		msg = COLOR_RED.."Vic> "..COLOR_END..msg;
	end
	DEFAULT_CHAT_FRAME:AddMessage( msg );
end

function Vic.VARIABLES_LOADED(...)
	VicFrame:UnregisterEvent("VARIABLES_LOADED");
	Vic.OptionsSetOptions();
end

function Vic.COMBAT_LOG_EVENT_UNFILTERED(...)
	-- http://www.wowwiki.com/API_COMBAT_LOG_EVENT
	_, _, Vic.event = select(1, ...);  -- frame, ts, event
	_, _, Vic.srcName, _, _, _, _, _, _, Vic.spellID, Vic.spellName = select(4, ...);
	if (Vic_options.enabled and Vic.spellID == 32216) then
		--Vic.Print(Vic.event .. ":"..Vic.spellID..":"..Vic.spellName..":"..Vic.srcName);
		if (string.find(Vic.event, "SPELL_AURA_APPLIED")) then
			if Vic_options.symbol then
				SetRaidTarget(Vic.srcName, Vic.raidIconValues[Vic_options.symbol]);
			else
				Vic.PartyPrint(Vic.spellName.." applied to "..Vic.srcName);
			end
		elseif (string.find(Vic.event, "SPELL_AURA_REFRESH")) then
			if Vic_options.symbol then
				SetRaidTarget(Vic.srcName, Vic.raidIconValues[Vic_options.symbol]);
			else
				Vic.PartyPrint(Vic.spellName.." refreshed on "..Vic.srcName);
			end
		elseif (string.find(Vic.event, "SPELL_AURA_REMOVED")) then
			if Vic_options.symbol then
				SetRaidTarget(Vic.srcName, 0);
			else
				Vic.PartyPrint(Vic.spellName.." removed from "..Vic.srcName);
			end
		else
			Vic.Print(Vic.event.." :: "..Vic.spellName);
		end
	end
end

function Vic.OptionsSetOptions()
	for text, v in pairs(Vic.raidIconValues) do
		if text == Vic_options["symbol"] then
			getglobal("VicOptionsFrame_RadioSymbol"..v):SetChecked(true);
		else
			getglobal("VicOptionsFrame_RadioSymbol"..v):SetChecked(false);
		end
	end
	if Vic_options["enabled"] then
		VicOptionsFrame_EnableBox:SetChecked(true);
	end
end

function Vic.OptionsRadioButtonClick(button)
	--Vic.Print("Post Click:"..button:GetName():sub(-1));
	clickValue = tonumber(button:GetName():sub(-1));
	for _,v in pairs(Vic.raidIconValues) do
		if v == clickValue then
			getglobal("VicOptionsFrame_RadioSymbol"..v):SetChecked(true);
		else
			getglobal("VicOptionsFrame_RadioSymbol"..v):SetChecked(false);
		end
	end
end

function Vic.OptionsOkay()
	--Vic.Print("OKAY");
	for symbol,v in pairs(Vic.raidIconValues) do
		if getglobal("VicOptionsFrame_RadioSymbol"..v):GetChecked() then
			--Vic.Print(symbol.." is checked.");
			Vic_options["symbol"] = symbol;
		end
	end
	Vic_options.enabled = VicOptionsFrame_EnableBox:GetChecked();
end

function Vic.OptionsCancel()
	-- When options CANCEL is pressed.
	Vic.OptionsSetOptions();
end

function Vic.Command(msg)
	InterfaceOptionsFrame_OpenToCategory("Victorious Reporter");
end
]]
