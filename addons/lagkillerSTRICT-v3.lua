//lagkiller 2002 S
//product of pastel

if (hoglan)
	error("Lagkiller was not loaded because another Lagkiller script is already present.")
end

rawset(_G, "hoglan", "true")

local MF_NOTHINK = MF_NOTHINK
local MF_NOBLOCKMAP = MF_NOBLOCKMAP
local TICRATE = TICRATE
local FRACBITS = FRACBITS

local fusemobjs = {}

fusemobjs[MT_NULL] = true
fusemobjs[MT_RAY] = true
fusemobjs[MT_PLAYER] = true
fusemobjs[MT_LAVAFALL] = true
fusemobjs[MT_FLAMEJET] = true
fusemobjs[MT_VERTICALFLAMEJET] = true
fusemobjs[MT_CHAINPOINT] = true
fusemobjs[MT_MACEPOINT] = true
fusemobjs[MT_BLUEFLAG] = true
fusemobjs[MT_REDFLAG] = true

local dist = 2000<<FRACBITS

local function telescan(fang, tree)
	if (tree.spawnfrozen)
		tree.flags = $ & ~MF_NOTHINK
		tree.spawnfrozen = false
		tree.fuse = TICRATE<<2
	end
end

local function spawnfreeze(mobj)
	if (mapheaderinfo[gamemap].lvlttl == "Hub") return nil end
	if not (mobj.valid) return nil end
	mobj.flags = $|MF_NOTHINK & ~MF_NOBLOCKMAP
	mobj.spawnfrozen = true
end

local function fusefreeze(mobj)
	if (mobj.spawnfrozen == false)
		mobj.flags = $|MF_NOTHINK
		mobj.spawnfrozen = true
		return true
	end
end

addHook("PlayerThink", function(player)
	if not (player.mo) return end
	if (player.mo.bot) return end
	searchBlockmap("objects", telescan, player.mo, player.mo.x-dist, player.mo.x+dist, player.mo.y-dist, player.mo.y+dist)
end)

for i = 0, #mobjinfo-1 do
	if (fusemobjs[i]) or (mobjinfo[i].flags & (MF_BOSS|MF_NOTHINK))
		continue
	else
		addHook("MapThingSpawn", spawnfreeze, i)
		addHook("MobjFuse", fusefreeze, i)
	end
end
