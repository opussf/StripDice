#!/usr/bin/env lua

require "wowTest"

StripDiceFrame = CreateFrame()

ParseTOC( "../src/StripDice.toc" )

test.outFileName = "testOut.xml"

-- addon setup
function test.before()
	myParty = { roster = {} }
	playerRange = {}
end
function test.after()
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
	StripDice.min = 1; StripDice.minWho = "Frank"
	StripDice.max = 99; StripDice.maxWho = "Bob"
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
	StripDice.min = 1; StripDice.minWho = "Frank"
	StripDice.max = 99; StripDice.maxWho = "Bob"
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
	StripDice.min = 1; StripDice.minWho = "Frank"
	StripDice.max = 99; StripDice.maxWho = "Bob"
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
	StripDice.min = 1; StripDice.minWho = "Frank"
	StripDice.max = 99; StripDice.maxWho = "Bob"
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
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_PARTY( {}, "roll" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 45 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Frank rolls 46 (1-100)" )
	assertEquals( 45, StripDice.min )
	assertEquals( "Bob", StripDice.minWho )
end
function test.test_CHAT_MSG_SYSTEM_rollSetsMax()
	myParty = { ["group"] = 1, ["roster"] = { "Frank","Bob" } }
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_PARTY( {}, "roll" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Bob rolls 55 (1-100)" )
	StripDice.CHAT_MSG_SYSTEM( {}, "Frank rolls 56 (1-100)" )
	assertEquals( 56, StripDice.max )
	assertEquals( "Frank", StripDice.maxWho )
end
----  Set options
function test.test_SetLowIcon_moon_CHAT_MSG_SAY()
	StripDice_options.lowIcon = 1  -- set to default (star)
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low roll to moon" )
	assertEquals( 5, StripDice_options.lowIcon )
end
function test.test_SetLowIcon_diamond_CHAT_MSG_SAY()
	StripDice_options.lowIcon = 1  -- set to default (star)
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low roll to {diamond}" )
	assertEquals( 3, StripDice_options.lowIcon )
end
function test.test_SetLowIcon_none_CHAT_MSG_SAY()
	StripDice_options.lowIcon = 1  -- set to default (star)
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set low roll to none" )
	assertIsNil( StripDice_options.lowIcon )
end
function test.test_SetHighIcon_moon_CHAT_MSG_SAY()
	StripDice_options.highIcon = 7  -- set to default (cross)
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high roll to moon" )
	assertEquals( 5, StripDice_options.highIcon )
end
function test.test_SetHighIcon_diamond_CHAT_MSG_SAY()
	StripDice_options.highIcon = 7  -- set to default (cross)
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high roll to {diamond}" )
	assertEquals( 3, StripDice_options.highIcon )
end
function test.test_SetHighIcon_none_CHAT_MSG_SAY()
	StripDice_options.highIcon = 7  -- set to default (cross)
	StripDice.PLAYER_ENTERING_WORLD()
	StripDice.CHAT_MSG_SAY( {}, "set high roll to none" )
	assertIsNil( StripDice_options.highIcon )
end

test.run()
