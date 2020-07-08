Welcome to Didit2.

Based on original addon by:
## Author: Parq of Bloodhoof
## Notes: /didit [party] reports the number of times each party member has cleared a dungeon to your chat window [or party chat]

Change log:
0.4     -- update logic, BfA dungeons
0.3b    -- Cata stats
0.2b    -- Party report
0.1b    -- Initial build
        -- Auto scan a player in a party with a mouse over
        -- Show info in the player tooltip
        -- cache the data so that duplicate scans are not needed.


To do:
-- Party report option


Didit_player[playername][statid].value


Didit_player = {
	["playername"] = {
		["statid"] = {
			["value"] = "5",
		}
		["error"] = "",
		["lookup"] = "",
	}
}
