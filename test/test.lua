#!/usr/bin/env lua

require "wowTest"

StripDiceFrame = CreateFrame()

ParseTOC( "../src/StripDice.toc" )

test.outFileName = "testOut.xml"

-- addon setup
function test.before()
	myParty = { roster = {} }
	playerRange = {}
	test.setDefaultIcons()
end
function test.after()

end
function test.setDefaultIcons()
	StripDice_options.lowIcon = {1}  -- low icon (star)
	StripDice_options.highIcon = {7} -- high icon (cross)
	StripDice_options.specificRollIcon = nil -- default value is nil
end

function test.test_HasSaveTable()
	-- assure that the save game table is created
	assertTrue( StripDice_games )
end
function test.test_OnLoad_Register_GROUP_ROSTER_UPDATE()
	StripDice.OnLoad()
	assertTrue( StripDiceFrame.Events.GROUP_ROSTER_UPDATE )
end
function test.test_OnLoad_Register_PLAYER_ENTERING_WORLD()
	StripDice.OnLoad()
	assertTrue( StripDiceFrame.Events.PLAYER_ENTERING_WORLD )
end
function test.test_GROUP_ROSTER_UPDATE_InParty_CHAT_MSG_SYSTEM()
	-- GROUP_ROSTER_UPDATE registers events in party
	myParty = { ["group"] = 2, ["roster"] = { "Zed" } }
	StripDice.GROUP_ROSTER_UPDATE()
	assertTrue( StripDiceFrame.Events.CHAT_MSG_SYSTEM )
	myParty = { ["group"] = nil, ["roster"] = {} }
	StripDice.GROUP_ROSTER_UPDATE()
	assertIsNil( StripDiceFrame.Events.CHAT_MSG_SYSTEM )
end
function test.test_GROUP_ROSTER_UPDATE_InParty_CHAT_MSG_SAY()
	-- GROUP_ROSTER_UPDATE registers events in party
	myParty = { ["group"] = 2, ["roster"] = { "Zed" } }
	StripDice.GROUP_ROSTER_UPDATE()
	assertTrue( StripDiceFrame.Events.CHAT_MSG_SAY )
	myParty = { ["group"] = nil, ["roster"] = {} }
	StripDice.GROUP_ROSTER_UPDATE()
	assertIsNil( StripDiceFrame.Events.CHAT_MSG_SAY )
end
function test.test_GROUP_ROSTER_UPDATE_InParty_CHAT_MSG_YELL()
	-- GROUP_ROSTER_UPDATE registers events in party
	myParty = { ["group"] = 2, ["roster"] = { "Zed" } }
	StripDice.GROUP_ROSTER_UPDATE()
	assertTrue( StripDiceFrame.Events.CHAT_MSG_YELL )
	myParty = { ["group"] = nil, ["roster"] = {} }
	StripDice.GROUP_ROSTER_UPDATE()
	assertIsNil( StripDiceFrame.Events.CHAT_MSG_YELL )
end
function test.test_GROUP_ROSTER_UPDATE_InParty_CHAT_MSG_PARTY()
	-- GROUP_ROSTER_UPDATE registers events in party
	myParty = { ["group"] = 2, ["roster"] = { "Zed" } }
	StripDice.GROUP_ROSTER_UPDATE()
	assertTrue( StripDiceFrame.Events.CHAT_MSG_PARTY )
	myParty = { ["group"] = nil, ["roster"] = {} }
	StripDice.GROUP_ROSTER_UPDATE()
	assertIsNil( StripDiceFrame.Events.CHAT_MSG_PARTY )
end
function test.test_GROUP_ROSTER_UPDATE_InParty_CHAT_MSG_PARTY_LEADER()
	-- GROUP_ROSTER_UPDATE registers events in party
	myParty = { ["group"] = 2, ["roster"] = { "Zed" } }
	StripDice.GROUP_ROSTER_UPDATE()
	assertTrue( StripDiceFrame.Events.CHAT_MSG_PARTY_LEADER )
	myParty = { ["group"] = nil, ["roster"] = {} }
	StripDice.GROUP_ROSTER_UPDATE()
	assertIsNil( StripDiceFrame.Events.CHAT_MSG_PARTY_LEADER )
end
function test.test_GROUP_ROSTER_UPDATE_InParty_CHAT_MSG_RAID()
	-- GROUP_ROSTER_UPDATE registers events in party
	myParty = { ["group"] = 2, ["roster"] = { "Zed" } }
	StripDice.GROUP_ROSTER_UPDATE()
	assertTrue( StripDiceFrame.Events.CHAT_MSG_RAID )
	myParty = { ["group"] = nil, ["roster"] = {} }
	StripDice.GROUP_ROSTER_UPDATE()
	assertIsNil( StripDiceFrame.Events.CHAT_MSG_RAID )
end
function test.test_GROUP_ROSTER_UPDATE_InParty_CHAT_MSG_RAID_LEADER()
	-- GROUP_ROSTER_UPDATE registers events in party
	myParty = { ["group"] = 2, ["roster"] = { "Zed" } }
	StripDice.GROUP_ROSTER_UPDATE()
	assertTrue( StripDiceFrame.Events.CHAT_MSG_RAID_LEADER )
	myParty = { ["group"] = nil, ["roster"] = {} }
	StripDice.GROUP_ROSTER_UPDATE()
	assertIsNil( StripDiceFrame.Events.CHAT_MSG_RAID_LEADER )
end
function test.test_GROUP_ROSTER_UPDATE_InParty_CHAT_MSG_INSTANCE_CHAT()
	-- GROUP_ROSTER_UPDATE registers events in party
	myParty = { ["group"] = 2, ["roster"] = { "Zed" } }
	StripDice.GROUP_ROSTER_UPDATE()
	assertTrue( StripDiceFrame.Events.CHAT_MSG_INSTANCE_CHAT )
	myParty = { ["group"] = nil, ["roster"] = {} }
	StripDice.GROUP_ROSTER_UPDATE()
	assertIsNil( StripDiceFrame.Events.CHAT_MSG_INSTANCE_CHAT )
end
function test.test_GROUP_ROSTER_UPDATE_InParty_CHAT_MSG_INSTANCE_CHAT_LEADER()
	-- GROUP_ROSTER_UPDATE registers events in party
	myParty = { ["group"] = 2, ["roster"] = { "Zed" } }
	StripDice.GROUP_ROSTER_UPDATE()
	assertTrue( StripDiceFrame.Events.CHAT_MSG_INSTANCE_CHAT_LEADER )
	myParty = { ["group"] = nil, ["roster"] = {} }
	StripDice.GROUP_ROSTER_UPDATE()
	assertIsNil( StripDiceFrame.Events.CHAT_MSG_INSTANCE_CHAT_LEADER )
end
function test.test_GROUP_ROSTER_UPDATE_LeavePartyStopsGame()
	StripDice.currentGame = time()
	StripDice.min = {1}; StripDice.minWho = { "Frank" }
	StripDice.max = {99}; StripDice.maxWho = { "Bob" }
	myParty = { ["group"] = nil, ["roster"] = {} }
	StripDice.GROUP_ROSTER_UPDATE()
	assertIsNil( StripDice.currentGame, "currentGame should be nil" )
	assertIsNil( StripDice.min, "min should be nil" )
	assertIsNil( StripDice.minWho, "minWho should be nil" )
	assertIsNil( StripDice.max, "max should be nil" )
	assertIsNil( StripDice.maxWho, "maxWho should be nil" )
end
function test.test_StopGame_clearsCurrentGame()
	StripDice.currentGame = time()
	StripDice.min = {1}; StripDice.minWho = {"Frank"}
	StripDice.max = {99}; StripDice.maxWho = {"Bob"}
	StripDice.StopGame()
	assertIsNil( StripDice.currentGame, "currentGame should be nil" )
	assertIsNil( StripDice.min, "min should be nil" )
	assertIsNil( StripDice.minWho, "minWho should be nil" )
	assertIsNil( StripDice.max, "max should be nil" )
	assertIsNil( StripDice.maxWho, "maxWho should be nil" )
end
function test.test_StartGame_InParty_CHAT_MSG_SAY()
	-- this should not
	StripDice.StopGame()
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	local now = time()
	StripDice.CHAT_MSG_SAY( {}, "Roll the dice!" )  -- the test that this event is registered is above
	assertEquals( now, StripDice.currentGame )
	assertTrue( StripDice_games[now] )
	assertIsNil( StripDice.min, "min should be nil" )
	assertIsNil( StripDice.minWho, "minWho should be nil" )
	assertIsNil( StripDice.max, "max should be nil" )
	assertIsNil( StripDice.maxWho, "maxWho should be nil" )
end
function test.test_StartGame_restartsGame_CHAT_MSG_SAY()
	StripDice.currentGame = time()-15    -- this keeps the game valid
	StripDice.min = {1}; StripDice.minWho = {"Frank"}
	StripDice.max = {99}; StripDice.maxWho = {"Bob"}
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	local now = time()
	StripDice.CHAT_MSG_SAY( {}, "Roll the dice!" )  -- the test that this event is registered is above
	assertEquals( now, StripDice.currentGame )
	assertTrue( StripDice_games[now] )
	assertIsNil( StripDice.min, "min should be nil" )
	assertIsNil( StripDice.minWho, "minWho should be nil" )
	assertIsNil( StripDice.max, "max should be nil" )
	assertIsNil( StripDice.maxWho, "maxWho should be nil" )
end
function test.test_StartGame_prunesOldGames()
	StripDice_games[1] = {}
	StripDice_games[2] = {}
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	local now = time()
	StripDice.CHAT_MSG_SAY( {}, "Roll the dice!" )  -- the test that this event is registered is above
	assertIsNil( StripDice_games[1] )
	assertIsNil( StripDice_games[2] )
end
function test.test_GameTimesOut()
	-- test that a started game is ended after 60 seconds
	StripDice.currentGame = time()-61    -- this keeps the game valid
	StripDice.min = {1}; StripDice.minWho = {"Frank"}
	StripDice.max = {99}; StripDice.maxWho = {"Bob"}
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "hello" )
	assertIsNil( StripDice.currentGame )
	assertIsNil( StripDice.min, "min should be nil" )
	assertIsNil( StripDice.minWho, "minWho should be nil" )
	assertIsNil( StripDice.max, "max should be nil" )
	assertIsNil( StripDice.maxWho, "maxWho should be nil" )
end
function test.test_CHAT_MSG_SYSTEM_performRoll()
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_PARTY( {}, "roll" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 15 (1-100)" )
	assertEquals( 15, StripDice_games[time()]["Bob"] )
	StripDice.CHAT_MSG_SYSTEM( {}, "Frank rolls 25 (1-100)" )
	assertEquals( 25, StripDice_games[time()]["Frank"] )
end
function test.test_CHAT_MSG_SYSTEM_rerolls()
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_PARTY( {}, "roll" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 35 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 95 (1-100)" )
	assertEquals( 35, StripDice_games[time()]["Bob"] )
end
function test.test_CHAT_MSG_SYSTEM_rollSetsMin()
	--test.setDefaultIcons()   -- low = 1-star, high = 7-cross
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_PARTY( {}, "roll" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 45 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Frank rolls 46 (1-100)" )
	assertEquals( 45, StripDice.min[1] )
	assertEquals( "Bob", StripDice.minWho[1] )
end
function test.test_CHAT_MSG_SYSTEM_rollSetsMax()
	--test.setDefaultIcons()
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_PARTY( {}, "roll" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 55 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Frank rolls 56 (1-100)" )
	assertEquals( 56, StripDice.max[1] )
	assertEquals( "Frank", StripDice.maxWho[1] )
end
----  Set options
function test.test_SetLowIcon_moon_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low roll to moon" )
	assertEquals( 5, StripDice_options.lowIcon[1] )
end
function test.test_SetLowIcon_diamond_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low roll to {diamond}" )
	assertEquals( 3, StripDice_options.lowIcon[1] )
end
function test.test_SetLowIcon_none_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low roll to none" )
	assertIsNil( StripDice_options.lowIcon[1] )
end
function test.test_SetLowIcon_skull_brief_ChAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low skull" )
	assertEquals( 8, StripDice_options.lowIcon[1] )
end
function test.test_SetLowIcon_square_badFormat_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low sqare" )
	assertEquals( 1, StripDice_options.lowIcon[1] )
end
function test.test_SetLowIcon_notgiven_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low" )
	assertEquals( 1, StripDice_options.lowIcon[1] )
	assertEquals( 7, StripDice_options.highIcon[1] )
end
function test.test_SetLowIcon_SameAsHighIcon_CHAT_MSG_SAY()
	-- this should probably clear the highIcon
	--test.setDefaultIcons()
	print( "high icon[1]: "..StripDice_options.highIcon[1] )
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low icon to cross" )
	assertEquals( 7, StripDice_options.lowIcon[1] )
	assertIsNil( StripDice_options.highIcon[1] )
end
function test.test_SetHighIcon_moon_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high roll to moon" )
	assertEquals( 5, StripDice_options.highIcon[1] )
end
function test.test_SetHighIcon_diamond_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high roll to {diamond}" )
	assertEquals( 3, StripDice_options.highIcon[1] )
end
function test.test_SetHighIcon_none_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high roll to none" )
	assertEquals( 0, #StripDice_options.highIcon, "this should be empty" )
end
function test.test_SetHighIcon_skull_brief_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high skull" )
	assertEquals( 8, StripDice_options.highIcon[1] )
end
function test.test_SetHighIcon_SameAsLowIcon_CHAT_MSG_SAY()
	-- this should probably clear the lowIcon
	--test.setDefaultIcons()   -- low = 1-star, high = 7-cross
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high icon to star" )
	assertEquals( 1, StripDice_options.highIcon[1] )
	assertIsNil( StripDice_options.lowIcon[1] )
end
function test.test_SetBoth_none_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high icon to none" )
	StripDice.CHAT_MSG_SAY( {}, "set low none" )
	assertIsNil( StripDice_options.highIcon[1] )
	assertIsNil( StripDice_options.lowIcon[1] )
end
function test.test_SetIcon_setalone_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set" )
	assertEquals( 1, StripDice_options.lowIcon[1] )
	assertEquals( 7, StripDice_options.highIcon[1] )
end
function test.test_SetIcon_noEndGiven_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set skull" )
	assertEquals( 1, StripDice_options.lowIcon[1] )
	assertEquals( 7, StripDice_options.highIcon[1] )
end
-------------------
-- Multiple settings
-------------------
function test.test_SetIcon_set2lowest_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice_options.highIcon[1] = 7
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low star cross" )
	assertEquals( 1, StripDice_options.lowIcon[1] )
	assertEquals( 7, StripDice_options.lowIcon[2] )
	assertIsNil( StripDice_options.highIcon[1] )
end
function test.test_SetIcon_set2highest_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice_options.highIcon[3] = 3
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high star diamond" )
	assertEquals( 1, StripDice_options.highIcon[1] )
	assertEquals( 3, StripDice_options.highIcon[2] )
	assertEquals( 2, #StripDice_options.highIcon )
	assertIsNil( StripDice_options.highIcon[3] )
end
function test.test_setIcon_setLowNone_clearsLow_CHAT_MSG_SAY()
	--test.setDefaultIcons()
	StripDice_options.lowIcon[2] = 3
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low none" )
	assertEquals( 0, #StripDice_options.lowIcon )
end
function test.test_CHAT_MSG_SYSTEM_rollSetsMin_multipleIcons()
	--test.setDefaultIcons()   -- low = 1-star, high = 7-cross
	StripDice_options.highIcon = {}
	StripDice_options.lowIcon[2] = 3
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_PARTY( {}, "roll" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Frank rolls 2 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 98 (1-100)" )
	assertEquals( 2, StripDice.min[1] )
	assertEquals( "Frank", StripDice.minWho[1] )
	assertEquals( 98, StripDice.min[2] )
	assertEquals( "Bob", StripDice.minWho[2] )
end
function test.test_CHAT_MSG_SYSTEM_rollSetsMin_SameValue()
	--test.setDefaultIcons()   -- low = 1-star, high = 7-cross
	StripDice_options.highIcon = {}
	StripDice_options.lowIcon[2] = 3
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_PARTY( {}, "roll" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Frank rolls 10 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 10 (1-100)" )
	assertEquals( 10, StripDice.min[1] )
	assertTrue( StripDice.minWho[1] == "Frank" or StripDice.minWho[2] == "Frank" )
	--assertEquals( "Frank", StripDice.minWho[1] )
	assertEquals( 10, StripDice.min[2] )
	assertTrue( StripDice.minWho[1] == "Bob" or StripDice.minWho[2] == "Bob" )
	--assertEquals( "Bob", StripDice.minWho[2] )
end
function test.test_CHAT_MSG_SYSTEM_rollSetsMin_groupOf4()
	--test.setDefaultIcons()   -- low = 1-star, high = 7-cross
	StripDice_options.highIcon = { 8, 7 }
	StripDice_options.lowIcon = { 1, 2 }
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_PARTY( {}, "roll" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Frank rolls 5 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 10 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Zed rolls 15 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Ivy rolls 71 (1-100)" )
	assertEquals( 5, StripDice.min[1] )
	assertEquals( "Frank", StripDice.minWho[1] )
	assertEquals( 10, StripDice.min[2] )
	assertEquals( "Bob", StripDice.minWho[2] )
end
function test.notest_CHAT_MSG_SYSTEM_tag2ndHighestAnd2ndLowest()
	-- @TODO: is this something I want to do?
	--test.setDefaultIcons()   -- low = 1-star, high = 7-cross
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SYSTEM( {}, "set high none star" )
	StripDice.CHAT_MSG_SYSTEM( {}, "set low none cross" )
	StripDice.CHAT_MSG_PARTY( {}, "roll" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Frank rolls 1 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 20 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Zed rolls 25 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Ivy rolls 69 (1-100)" )
	assertEquals( 1, StripDice.min[1] )
	assertEquals( "Frank", StripDice.minWho[1] )
	assertEquals( 20, StripDice.min[2] )
	assertEquals( "Bob", StripDice.minWho[2] )
end

-----------------------------------------
-- Tests for setting an icon for a specific roll

function test.test_CHAT_MSG_SYSTEM_setSpecificRollValue()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set 69 to circle" )
	assertEquals( 2, StripDice_options.specificRollIcon[69] )
end
function test.test_CHAT_MSG_SYSTEM_setSpecificRollValue_brief()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set 69 circle" )
	assertEquals( 2, StripDice_options.specificRollIcon[69] )
end
function test.test_CHAT_MSG_SYSTEM_setSpecificRollValue_clear()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set 69 circle" )
	--assertEquals( 2, StripDice_options.specificRollIcon[69] )
	StripDice.CHAT_MSG_SAY( {}, "set 69 none" )
	assertIsNil( StripDice_options.specificRollIcon )
end
function test.test_CHAT_MSG_SYSTEM_setSpecificRollValue_takesIconFromLow()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low circle" )
	--assertEquals( 2, StripDice_options.lowIcon[1] )
	StripDice.CHAT_MSG_SAY( {}, "set 69 circle" )
	assertIsNil( StripDice_options.lowIcon[1] )
end
function test.test_CHAT_MSG_SYSTEM_setSpecificRollValue_takesIconFromLow_multiple_clearLow()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low circle star" )
	--assertEquals( 2, StripDice_options.lowIcon[1] )
	StripDice.CHAT_MSG_SAY( {}, "set 69 circle" )
	assertEquals( 1, StripDice_options.lowIcon[1] )
end
function test.test_CHAT_MSG_SYSTEM_setSpecificRollValue_takesIconFromHigh()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high circle" )
	--assertEquals( 2, StripDice_options.lowIcon[1] )
	StripDice.CHAT_MSG_SAY( {}, "set 69 circle" )
	assertIsNil( StripDice_options.highIcon[1] )
end
function test.test_CHAT_MSG_SYSTEM_setSpecificRollValue_takesIconFromHigh_multiple_clearLow()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high circle star" )
	--assertEquals( 2, StripDice_options.lowIcon[1] )
	StripDice.CHAT_MSG_SAY( {}, "set 69 circle" )
	assertEquals( 1, StripDice_options.highIcon[1] )
end
function test.test_CHAT_MSG_SYSTEM_setHasNoGoodSettings()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set into the sun" )
	assertEquals( 1, StripDice_options.highIcon[1] )
end

-----------------------------------------
-- Tests for settings report
function test.test_CHAT_MSG_SYSTEM_report()
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "settings" )
	assertEquals( "High rolls: {cross}, Low rolls: {star}", StripDice_log[#StripDice_log][time()] )
end

test.run()
