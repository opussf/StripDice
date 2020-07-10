#!/usr/bin/env lua

addonData = { ["Version"] = "1.0",
}

require "wowTest"

test.outFileName = "testOut.xml"

-- Figure out how to parse the XML here, until then....
DiditFrame = CreateFrame()
SendMailNameEditBox = CreateFontString("SendMailNameEditBox")
GameTooltip = CreateFrame( "GameTooltip", "tooltip" )

-- require the file to test
package.path = "../src/?.lua;'" .. package.path
require "DiditData"
require "Didit"


function test.before()
	Didit.debug = nil
	Didit.OnLoad()
	myParty = { roster = {} }
	playerRange = {}
	--print( "----> START!" )
end
function test.after()
	--print( "END! <-----" )
end

-- GROUP_ROSTER_UPDATE
-- Probably not actually needed
function test.test_EventRegistered_GROUP_ROSTER_UPDATE()
	assertTrue( DiditFrame.Events.GROUP_ROSTER_UPDATE )
end
function test.test_DoEvent_GROUP_ROSTER_UPDATE()
	Didit.GROUP_ROSTER_UPDATE()
end

-- PLAYER_ENTERING_WORLD
function test.test_EventRegistered_PLAYER_ENTERING_WORLD()
	assertTrue( DiditFrame.Events.PLAYER_ENTERING_WORLD )
end
function test.test_DoEvent_PLAYER_ENTERING_WORLD()
	-- event code exists
	Didit.PLAYER_ENTERING_WORLD()
end
function test.test_DoEvent_PLAYER_ENTERING_WORLD_NotInInstance()
	-- assert that   Didit.inDungeon and Didit.statisticID are nil
	Didit.inDungeon = true
	Didit.statisticID = 16
	Didit.PLAYER_ENTERING_WORLD()
	assertIsNil( Didit.inDungeon )
	assertIsNil( Didit.statisticID )
end
function test.test_DoEvent_PLAYER_ENTERING_WORLD_InParty()
	-- assert that   Didit.inDungeon is true, and Didit.statisticID gets set
	myParty = { party = true, roster = {} }
	Didit.PLAYER_ENTERING_WORLD()
	assertTrue( Didit.inDungeon )
	assertEquals( 5738, Didit.statisticID ) -- Deadmines - Normal
end

-- ScanPlayers
function test.test_ScanPlayers_party_registersEvent()
	Didit.statisticID = 16
	Didit.inDungeon = true
	Didit.scanName = nil
	Didit.lookupPre = "party" -- this would normally be set in PLAYER_ENTERING_WORLD
	myParty = { ["party"] = true, roster = { "skippy", "pupper" } }
	playerRange = { ["party1"] = 20 }  -- 20 yards, within scanning range
	Didit.ScanPlayers()

	assertTrue( DiditFrame.Events.INSPECT_ACHIEVEMENT_READY )
end
function test.test_ScanPlayers_raid_registersEvent()
	Didit.statisticID = 16
	Didit.inDungeon = true
	Didit.scanName = nil
	Didit.lookupPre = "raid" -- this would normally be set in PLAYER_ENTERING_WORLD
	myParty = { ["raid"] = true, roster = { "skippy", "pupper" } }
	playerRange = { ["raid1"] = 20 } -- 20 yards, within scanning range
	Didit.ScanPlayers()

	assertTrue( DiditFrame.Events.INSPECT_ACHIEVEMENT_READY )
end
function test.test_ScanPlayers_party_outOfRange()
	Didit.statisticID = 16
	Didit.inDungeon = true
	Didit.scanName = nil
	Didit.lookupPre = "party" -- this would normally be set in PLAYER_ENTERING_WORLD
	myParty = { ["party"] = true, roster = { "skippy", "pupper" } }
	playerRange = { ["party1"] = 50 }
	Didit.ScanPlayers()

	assertEquals( "Out of Range", Didit_players["skippy"].error )
end

function test.test_ScanPlayers_party_initsPlayerStruct()
	Didit_players = {}
	Didit.statisticID = 16
	Didit.inDungeon = true
	Didit.scanName = nil
	Didit.lookupPre = "raid" -- this would normally be set in PLAYER_ENTERING_WORLD
	myParty = { ["raid"] = true, roster = { "skippy", "pupper" } }
	Didit.ScanPlayers()

	-- double check, but I feel ok with this as it is checking a structure, depth wise.
	assertTrue( Didit_players["skippy"], "Skippy key does not exist" )
	assertTrue( Didit_players["skippy"][16], "statID does not exist for Skippy" )
end
function test.test_ScanPlayers_party_noStatToScan()
	-- has no side effects, don't break
	Didit.statisticID = nil
	Didit.ScanPlayers()
end

function test.test_DoEvent_INSPECT_ACHIEVEMENT_READY_setsValue()
	Didit_players = {}
	Didit.statisticID = 5738
	Didit.inDungeon = true
	Didit.scanName = nil
	Didit.lookupPre = "raid" -- this would normally be set in PLAYER_ENTERING_WORLD
	myParty = { ["raid"] = true, roster = { "skippy", "pupper" } }
	playerRange = { ["raid1"] = 20 } -- 20 yards, within scanning range
	Didit.ScanPlayers()
	Didit.INSPECT_ACHIEVEMENT_READY()

	assertEquals( "6", Didit_players["skippy"][5738].value )
end
function test.test_DoEvent_INSPECT_ACHIEVEMENT_READY_setsStatsName()
	Didit_players = {}
	Didit.statisticID = 5738
	Didit.inDungeon = true
	Didit.scanName = nil
	Didit.lookupPre = "raid" -- this would normally be set in PLAYER_ENTERING_WORLD
	myParty = { ["raid"] = true, roster = { "skippy", "pupper" } }
	playerRange = { ["raid1"] = 20 } -- 20 yards, within scanning range
	Didit.ScanPlayers()
	Didit.INSPECT_ACHIEVEMENT_READY()

	assertEquals( "Deadmines", Didit_players["skippy"][5738].name )
end
function test.test_DoEvent_INSPECT_ACHIEVEMENT_READY_setsScanTime()
	Didit_players = {}
	Didit.statisticID = 5738
	Didit.inDungeon = true
	Didit.scanName = nil
	Didit.lookupPre = "raid" -- this would normally be set in PLAYER_ENTERING_WORLD
	myParty = { ["raid"] = true, roster = { "skippy", "pupper" } }
	playerRange = { ["raid1"] = 20 } -- 20 yards, within scanning range
	Didit.ScanPlayers()
	Didit.INSPECT_ACHIEVEMENT_READY()

	assertEquals( time(), Didit_players["skippy"][5738].scannedAt )
end
function test.test_DoEvent_INSPECT_ACHIEVEMENT_READY_clearsError()
	Didit_players = { ["skippy"] = { ["error"] = "Frockling in the flowers" } }
	Didit.statisticID = 5738
	Didit.inDungeon = true
	Didit.scanName = nil
	Didit.lookupPre = "raid" -- this would normally be set in PLAYER_ENTERING_WORLD
	myParty = { ["raid"] = true, roster = { "skippy", "pupper" } }
	playerRange = { ["raid1"] = 20 } -- 20 yards, within scanning range
	Didit.ScanPlayers()
	Didit.INSPECT_ACHIEVEMENT_READY()

	assertIsNil( Didit_players["skippy"].error )
end
function test.test_DoEvent_INSPECT_ACHIEVEMENT_READY_clearsScanName()
	Didit_players = { ["skippy"] = { ["error"] = "Frockling in the flowers" } }
	Didit.statisticID = 5738
	Didit.inDungeon = true
	Didit.scanName = nil
	Didit.lookupPre = "raid" -- this would normally be set in PLAYER_ENTERING_WORLD
	myParty = { ["raid"] = true, roster = { "skippy", "pupper" } }
	playerRange = { ["raid1"] = 20 } -- 20 yards, within scanning range
	Didit.ScanPlayers()
	Didit.INSPECT_ACHIEVEMENT_READY()

	assertIsNil( Didit.scanName )
end
function test.test_DoEvent_INSPECT_ACHIEVEMENT_READY_unregistersEvent()
	Didit_players = { ["skippy"] = { ["error"] = "Frockling in the flowers" } }
	Didit.statisticID = 5738
	Didit.inDungeon = true
	Didit.scanName = nil
	Didit.lookupPre = "raid" -- this would normally be set in PLAYER_ENTERING_WORLD
	myParty = { ["raid"] = true, roster = { "skippy", "pupper" } }
	playerRange = { ["raid1"] = 20 } -- 20 yards, within scanning range
	Didit.ScanPlayers()
	Didit.INSPECT_ACHIEVEMENT_READY()

	assertIsNil( DiditFrame.Events.INSPECT_ACHIEVEMENT_READY )
end

-- report
function test.test_Report_noStats_nilReportTable()
	myParty = { ["party"] = true, roster = { "skippy" } }
	Didit.report = nil
	Didit.statisticID = nil

	Didit.Report()
	assertIsNil( Didit.report )
end
function test.test_Report_ChatChannel_Instance_NotInInstance_InParty()
	Didit.statisticID = 5738
	myParty = { ["party"] = true, roster = { "skippy" } }
	chatChannel = Didit.Report( "INSTANCE" )
	assertEquals( "PARTY", chatChannel )
end
function test.test_Report_ChatChannel_Instance_InInstance()
	Didit.statisticID = 5738
	myParty = { ["instance"] = true, roster = { "skippy" } }
	chatChannel = Didit.Report( "INSTANCE" )
	assertEquals( "INSTANCE_CHAT", chatChannel )
end
function test.test_Report_ChatChannel_Party_InParty()
	Didit.statisticID = 5738
	myParty = { ["party"] = true, roster = { "skippy" } }
	chatChannel = Didit.Report( "PARTY" )
	assertEquals( "PARTY", chatChannel )
end
function test.test_Report_ChatChannel_Party_NotInParty()
	Didit.statisticID = 5738
	myParty = { ["party"] = nil, roster = { } }
	chatChannel = Didit.Report( "PARTY" )
	assertEquals( "SAY", chatChannel )
end
function test.test_Report_ChatChannel_Guild_InGuild()
	Didit.statisticID = 5738
	myGuild = { ["name"] = "Test Guild", }
	chatChannel = Didit.Report( "GUILD" )
	assertEquals( "GUILD", chatChannel )
end
function test.test_Report_ChatChannel_Guild_NotInGuild()
	Didit.statisticID = 5738
	myGuild = { }
	chatChannel = Didit.Report( "GUILD" )
	assertEquals( "SAY", chatChannel )
end
function test.test_Report_ReportTable_Title()
	myParty = { ["roster"] = {} }
	Didit.statisticID = 5738
	Didit_players = {}

	Didit.Report( "SAY" )
	assertEquals( "How many Deadmines do *you* have?", Didit.report[1] )
end
function test.test_Report_ReportTable_StatLine()
	Didit.statisticID = 5738
	myParty = { ["party"] = true, roster = { "skippy" } }
	Didit_players = { ["testPlayer"] = { [5738] = { ["value"] = 5 } } }
	Didit.Report( "SAY" )
	assertEquals( "...  5 for testPlayer", Didit.report[2] )
end
function test.test_Report_ReportTable_Error()
	myParty = { ["party"] = true, roster = { "skippy" } }
	Didit.statisticID = 5738
	Didit.lookupPre = "party" -- this would normally be set in PLAYER_ENTERING_WORLD
	Didit_players = { ["testPlayer"] = { [5738] = { ["value"] = 5 } } }
	Didit_players["skippy"] = { ["error"] = "Out of range" }

	Didit.Report( "SAY" )

	assertEquals( "Error: Out of range for skippy", Didit.report[3] )
end
function test.test_Report_ReportTable_NotScanned()
	-- no stat, no error
	myParty = { ["party"] = true, roster = { "skippy" } }
	Didit.statisticID = 5738
	Didit.lookupPre = "party" -- this would normally be set in PLAYER_ENTERING_WORLD
	Didit_players = { ["testPlayer"] = { [5738] = { ["value"] = 5 } } }
	Didit_players["skippy"] = { }

	Didit.Report( "SAY" )

	assertEquals( "skippy has not yet been scanned.", Didit.report[3] )
end
---  tooltip tests....  @TODO

---  cmd tests
function test.test_DoCmd_01()
	Didit.Cmd()
end
function test.test_DoCmd_debug()
	Didit.debug = nil

	Didit.Cmd( "debug" )

	assertTrue( Didit.debug )
end
function test.test_DoCmd_reset()
	Didit_players = { ["testPlayer"] = { [5738] = { ["value"] = 5 } } }

	Didit.Cmd( "reset" )

	local count = 0
	for _,_ in pairs( Didit_players ) do
		count = count + 1
	end

	assertEquals( 0, count )
end
function test.test_DoCmd_help()
	Didit.Cmd( "help" )
end

test.run()
