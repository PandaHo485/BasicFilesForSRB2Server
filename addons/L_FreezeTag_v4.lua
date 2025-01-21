--Freeze Tag v4.0
--A gamemode conversion mod by Hatninja (Smol Mallow#6945), now ported to v2.2.
--Feel free to modify and distribute however you like!

--Recommended Settings:
--specialrings off
--restrictskinchange off

COM_AddCommand("FT_HELP", function(serv)
	CONS_Printf(serv,
[[~~Freeze Tag Commands~~
FT_TIME - How long rounds last (In minutes.)
FT_WAIT - How long before a round begins (In seconds.)
FT_TAGCOST - How many rings a tag costs.
FT_ARMACOST - How many rings armageddon shield costs.
FT_SCOOTCOST - How many rings to scoot.
FT_RATIO - Percentage of taggers. High values will likely cause problems.
FT_BSPD - Scale of character's normal speed when at 0 power.
FT_PSCALE - Percentage of Power stat increases. At 100%, 1 ring is a unit. 
FT_GUIDE - 0: Disable all. 1: Enable Tooltips. 2: Enable welcome message.
FT_RADAR - Enable or Disable the radar feature.
FT_RADARWARN - Toggle Radar color warning based on contents. (Risk of flashing colors!)
FT_RADARSCALE - Sets the Radar's distance.
FT_AUTO - Enable/disable auto-assignment.
FT_UINF - Unfreeze invincibility length.
FT_MAXRINGS - Ring/Power cap.
]])
end,0)

local welcometitle = "Welcome to Freeze Tag!"
local welcomemsg = "Players are automatically\nassigned Tagger or Runner.\nTaggers win if all runners\nare frozen by touch.\nRunners win by staying\nalive before the clock.\nAll tags require POWER.\nPower builds when you get\nrings, as well as speed!\nHave fun!\n-ATTACK to close-"

--[[CVars]]
local gametime=5*60*TICRATE --How long rounds last.
CV_RegisterVar({name="FT_TIME",defaultvalue="5.0",
	flags=CV_CALL|CV_FLOAT|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN = FRACUNIT, MAX = FRACUNIT*20},
	func=function(cv)
		gametime=(cv.value*60/FRACUNIT)*TICRATE
	end
})

local waittime=20*TICRATE --How long to wait before the round starts.
CV_RegisterVar({name="FT_WAIT",defaultvalue="20",
	flags=CV_CALL|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN = 0, MAX = 120},
	func=function(cv)
		waittime=cv.value*TICRATE
	end
})

local tagcost=5 --How many rings a tag costs.
CV_RegisterVar({name="FT_TAGCOST",defaultvalue="5",
	flags=CV_CALL|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN = 0, MAX = 100},
	func=function(cv)
		tagcost=cv.value
	end
})


local armacost=175 --How many rings a tag costs.
CV_RegisterVar({name="FT_ARMACOST",defaultvalue="175",
	flags=CV_CALL|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN = 0, MAX = 1000},
	func=function(cv)
		armacost=cv.value
	end
})

local scootcost=5 --How many rings a tag costs.
CV_RegisterVar({name="FT_SCOOTCOST",defaultvalue="5",
	flags=CV_CALL|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN = 0, MAX = 1000},
	func=function(cv)
		scootcost=cv.value
	end
})

local itratio=FRACUNIT/2 --Percentage of taggers. High values will likely cause problems.
CV_RegisterVar({name="FT_RATIO",defaultvalue="0.5",
	flags=CV_CALL|CV_FLOAT|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN = 0, MAX = FRACUNIT},
	func=function(cv)
		itratio=cv.value
	end
})

local basespeed = (FRACUNIT*4)/6
CV_RegisterVar({name="FT_BSPD",defaultvalue="0.6",
	flags=CV_CALL|CV_FLOAT|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN = FRACUNIT/10, MAX = FRACUNIT*3},
	func=function(cv)
		basespeed=cv.value
	end
})

local pscale=FRACUNIT/20
CV_RegisterVar({name="FT_PSCALE",defaultvalue="0.05",
	flags=CV_CALL|CV_FLOAT|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN=0,MAX=FRACUNIT},
	func=function(cv)
		pscale=cv.value
	end
})

local radarwarn=0
CV_RegisterVar({name="FT_RADARWARN",defaultvalue="Off",
	flags=CV_CALL|CV_NOINIT|CV_SHOWMODIF,
	PossibleValue={Off=0,On=1},
	func=function(cv)
		radarwarn=cv.value
	end
})

local radar=1
CV_RegisterVar({name="FT_RADAR",defaultvalue="On",
	flags=CV_CALL|CV_NOINIT|CV_SHOWMODIF,
	PossibleValue={Off=0,On=1},
	func=function(cv)
		radar=cv.value
	end
})

local radarscale=(45*FRACUNIT)
CV_RegisterVar({name="FT_RADARSCALE",defaultvalue="45.0",
	flags=CV_CALL|CV_FLOAT|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN=FRACUNIT,MAX=FRACUNIT*500},
	func=function(cv)
		radarscale=cv.value
	end
})

local guide=2
CV_RegisterVar({name="FT_GUIDE",defaultvalue="2",
	flags=CV_CALL|CV_NOINIT|CV_SHOWMODIF,
	PossibleValue={MIN=0,MAX=2},
	func=function(cv)
		guide=cv.value
	end
})

local auto=1
CV_RegisterVar({name="FT_AUTO",defaultvalue="On",
	flags=CV_CALL|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={Off=0,On=1},
	func=function(cv)
		auto=cv.value
	end
})

local uif=TICRATE/3
CV_RegisterVar({name="FT_UINF",defaultvalue="0.33",
	flags=CV_CALL|CV_NOINIT|CV_FLOAT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN = 0, MAX = FRACUNIT*20},
	func=function(cv)
		uif=FixedMul(cv.value,TICRATE*FRACUNIT)/FRACUNIT
	end
})

local maxrings=1000
CV_RegisterVar({name="FT_MAXRINGS",defaultvalue="1000",
	flags=CV_CALL|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue={MIN = 0, MAX = 1000},
	func=function(cv)
		maxrings=cv.value
	end
})

--[[Gamemode Constants]]
local color_unassigned = 80 
local color_it = 35
local color_itblink = 55
local color_runner = 150
local color_frozen = 134		

local points_tag = 50
local points_unfreeze = 50
local points_keepalive = 2
local points_aliverate = 3

local sound_freeze = sfx_cdfm51 --sfx_s3k42 --31 is a good obtain
local sound_unfreeze = sfx_wbreak --sfx_s3k47
local sound_superjump = sfx_zoom
local sound_armaget = sfx_armasg
local sound_armause = sfx_bowl --Only on successful hit.
local sound_timeclose = sfx_cdfm74
local sound_scoot = sfx_bnce1

local gfx_IT = "TAGICO"
local gfx_frz = "CHAOS4"
local gfx_sfrz = "CHAOS3"

local armageddon_range = 450*FRACUNIT

local timeclose = 30*TICRATE

freeslot("TOL_FREEZETAG")

G_AddGametype({
    name = "Freeze Tag",
    identifier = "freezetag",
    typeoflevel = TOL_MATCH|TOL_TAG|TOL_CTF|TOL_FREEZETAG,
    rules = GTR_TIMELIMIT|GTR_NOSPECTATORSPAWN|GTR_SPECTATORS|GTR_DEATHMATCHSTARTS|GTR_POWERSTONES,
    rankingtype = GT_MATCH,
	intermissiontype = int_match,
    headerleftcolor = color_frozen,
    headerrightcolor = color_runner,
    description = "Chase and run in this team-based mode! Unfreeze your teammates and stay alive as a runner. But be warned, taggers win if they capture everyone!"
})

--[[Misc Gamemode Functions]]
local function makeFrozen(pl)
	pl.pflags = $1 | PF_INVIS
	pl.powers[pw_shield] = 0
	pl.powers[pw_flashing] = 100
	pl.powers[pw_nocontrol] = 32767

	S_FadeMusic(50, MUSICRATE/2, pl)
end
local function makeSuperFrozen(pl)
	makeFrozen(pl)
	pl.superfrozen = true
end
local function makeUnfrozen(pl)
	pl.pflags = $1 & ~PF_INVIS
	pl.powers[pw_nocontrol] = 0
	pl.powers[pw_flashing] = 0
	pl.powers[pw_underwater] = 23*TICRATE
	
	pl.mo.state = S_PLAY_STND
	pl.mo.tics = 1
	pl.superfrozen = false
	
	S_StopFadingMusic(pl)
	S_SetInternalMusicVolume(100,pl)
end
local function isFrozen(pl)
	return (pl.pflags & PF_INVIS)
end
local function isSuperFrozen(pl)
	return pl.superfrozen
end
local function makeIt(pl,doprint)
	if doprint then print("\x85"+pl.name+" is now IT!") end
	
	pl.pflags = $1 | PF_TAGIT
	makeUnfrozen(pl)
	
	P_PlayerEmeraldBurst(pl)
	pl.tossdelay = 100
end
local function makeNotIt(pl,doprint)
	if doprint then print("\x84"+pl.name+" is now a runner!") end
	
	pl.pflags = $1 & ~PF_TAGIT
end
local function isIt(pl)
	return pl.pflags & PF_TAGIT
end
local function isPlayerActive(pl)
	return pl.mo and not pl.spectator
end
local function doCostCheck(pl,cost)
	if pl.rings >= cost then
		pl.rings = $1-cost
		return true
	end
	return false
end
local function doFreeze(mo1,mo2)
	if not doCostCheck(mo1.player,tagcost) then return end
	--Invincible players can't be frozen.
	if mo2.player.powers[pw_invulnerability] ~= 0 then return end
	
	if mo1.player.powers[pw_invulnerability] ~= 0 then
		makeSuperFrozen(mo2.player)
	else
		makeFrozen(mo2.player)
	end
	
	if mo2.player.climbing ~= 1 then
		P_DoPlayerPain(mo2.player,mo1)
	end
	P_PlayerEmeraldBurst(mo2.player)
	
	P_AddPlayerScore(mo1.player, points_tag)
	S_StartSound(mo2, sound_freeze, pl)
	print("\x85"+mo1.player.name+"\x80 froze \x84"+mo2.player.name+"\x80!")
	return true
end
local function doUnfreeze(mo1,mo2)
	if not doCostCheck(mo1.player,tagcost) then return end
	P_AddPlayerScore(mo1.player, points_unfreeze)
	
	makeUnfrozen(mo2.player)
	
	mo2.player.powers[pw_invulnerability] = uif
		 	
	P_AddPlayerScore(mo1.player, points_keepalive)
	S_StartSound(mo2, sound_unfreeze, pl)
	print("\x84"+mo1.player.name+"\x80 unfroze \x84"+mo2.player.name+"\x80!")
	return true
end
local function countPlayers()
	local count,frozen,it=0,0,0
	for pl in players.iterate
		if pl.spectator then continue end
		
		if isFrozen(pl) then frozen=$+1 end
		if isIt(pl) then it=$+1 end
		count=count+1
	end
	return count,frozen,it
end
local function makeRandomIt(doprint)
	local count,frozen,its = countPlayers()
	local random = P_RandomRange(1,count-its)
	local i = 0
	local found
	for pl in players.iterate
		if not isPlayerActive(pl) then continue end
		if isIt(pl) then continue end
		if pl.opt == 2 then continue end
		i=i+1
		if i == random then
			makeIt(pl,doprint)
			found=true
			break
		end
	end
	return found
end
local function makeRandomNotIt(doprint)
	local count,frozen,its = countPlayers()
	local random = P_RandomRange(1,its)
	local i = 0
	local found
	for pl in players.iterate
		if not isPlayerActive(pl) then continue end
		if not isIt(pl) then continue end
		if pl.opt == 1 then continue end
		i=i+1
		if i == random then
			makeNotIt(pl,doprint)
			found=true
			break
		end
	end
	return found
end
local function isInGamemode()
	return gametype == GT_FREEZETAG
end
local function getTaggersForCount(c)
	if c <= 4 then return 1 end
	if c <= 5 then return 2 end
	return FixedMul(c*FRACUNIT,itratio)/FRACUNIT
end
local function getEmeralds(emmask)
	local count = 0
	for i,flag in pairs{EMERALD1,EMERALD2,EMERALD3,EMERALD4,EMERALD5,EMERALD6,EMERALD7} do
		if emmask & flag then
			count=$+1
		end
	end
	return count
end

--[[Gamemode Logic]]
addHook("MobjCollide", function(mo2,mo1)
	if not isInGamemode() then return end
	if not mo1.player or not mo2.player then return end
	if not (mo1.z+mo1.height > mo2.z and mo2.z+mo2.height > mo1.z) then return end
       
	local pl1,pl2 = mo1.player,mo2.player
	if isIt(pl1) and not isIt(pl2) then
		if not isFrozen(pl2) then
			doFreeze(mo1,mo2)
		end
       	if mo2.player.powers[pw_invulnerability] ~= 0 then
			P_DoPlayerPain(mo1.player,mo2)
		end
	end
	if not isIt(pl1) and not isIt(pl2)
       and isFrozen(pl2) and not isFrozen(pl1) then
		local superfrz = isSuperFrozen(pl2)
		local unfroze = doUnfreeze(mo1,mo2)
		if unfroze and superfrz then
			P_DoPlayerPain(mo1.player,mo2)
		end
	end
       
	--Anti-camp.
	if isIt(pl2) and isFrozen(pl1)
       and pl1.mo.momx == 0
       and pl1.mo.momy == 0
       and pl2.rings >= 5
       and leveltime % 2 == 0 then 
       
       pl2.rings = $-5
       pl1.rings = $+5
	end
end, MT_PLAYER)

--Taggers can't collect emeralds.
local function noEmeraldTouch(mo1,mo2)
	if not isInGamemode() then return end
	if not isIt(mo2.player) then return end
	return true
end
addHook("TouchSpecial",noEmeraldTouch,MT_EMERALD1)
addHook("TouchSpecial",noEmeraldTouch,MT_EMERALD2)
addHook("TouchSpecial",noEmeraldTouch,MT_EMERALD3)
addHook("TouchSpecial",noEmeraldTouch,MT_EMERALD4)
addHook("TouchSpecial",noEmeraldTouch,MT_EMERALD5)
addHook("TouchSpecial",noEmeraldTouch,MT_EMERALD6)
addHook("TouchSpecial",noEmeraldTouch,MT_EMERALD7)
addHook("TouchSpecial",noEmeraldTouch,MT_FLINGEMERALD)


addHook("MapLoad", function()
	if isInGamemode() then
		hud.disable("weaponrings")
		hud.disable("score")
		hud.disable("rings")
		hud.disable("time")
		hud.disable("lives")
	else
		hud.enable("weaponrings")
		hud.enable("score")
		hud.enable("rings")
		hud.enable("time")
		hud.enable("lives")
	end
end)

local function generalAbility(pl)
	--Rings Speed Scale
	local speedup = pl.rings*pscale
	local defspeed=skins[pl.mo.skin].normalspeed
	defspeed=FixedMul(defspeed,basespeed)
	local defaccel=skins[pl.mo.skin].acceleration
	if pl.normalspeed ~= defspeed+speedup then
		pl.normalspeed = defspeed+speedup
		pl.acceleration = defaccel+speedup/FRACUNIT
	end
	
	if skins[pl.mo.skin].ability == CA_FLY
	or skins[pl.mo.skin].ability == CA_GLIDEANDCLIMB then
		pl.actionspd = skins[pl.mo.skin].actionspd+speedup/2
	end
	
	if skins[pl.mo.skin].ability2 ~= CA2_SPINDASH then
		pl.jumpfactor = skins[pl.mo.skin].jumpfactor+speedup/10
	end

	--Super Jump for characters that don't have good vertical ability (Sonic)
	if skins[pl.mo.skin].ability ~= CA_FLY
	and skins[pl.mo.skin].ability ~= CA_GLIDEANDCLIMB then
		if pl.dashspeed > 0 and (pl.cmd.buttons & BT_JUMP) then
			pl.pflags =$ & ~PF_STARTJUMP
			pl.pflags =$ & ~PF_STARTJUMP
			pl.pflags =$ | PF_JUMPED
			pl.mo.momz=$+pl.dashspeed/3
			pl.mo.momx=0
			pl.mo.momy=0
		
			S_StartSound(pl.mo, sound_superjump, pl)
		end
	end
	
	--Nerf Sonic's Thok
	if skins[pl.mo.skin].ability == CA_THOK then
		pl.actionspd = 45*FRACUNIT
		--Air strafe strats too strong:
		--max(pl.speed+10*FRACUNIT,45*FRACUNIT)
	end
	
	--Armageddon Get
	if pl.powers[pw_shield] ~= SH_ARMAGEDDON
	and pl.dashspeed == pl.maxdash
	and pl.cmd.buttons & BT_ATTACK
	and doCostCheck(pl,armacost) then
		pl.powers[pw_shield] = SH_ARMAGEDDON
		P_SpawnShieldOrb(pl)
		S_StartSound(pl.mo,sound_armaget)
		pl.pflags = $ & ~PF_STARTDASH
		pl.dashspeed = 0
	end
	
	--Attraction Shield nerf
	if pl.powers[pw_shield] == SH_ATTRACT and pl.preshrings then
		if pl.rings < pl.preshrings or pl.rings > pl.preshrings+100 then
			P_RemoveShield(pl)
			pl.powers[pw_shield] = 0
			pl.preshrings = 0
		end
	end
end

local function taggerAbility(pl)
end

local function runnerAbility(pl)
	if isFrozen(pl) then
		--Suicide shortcut
		if (pl.cmd.buttons & BT_ATTACK) and (pl.cmd.buttons & BT_SPIN) and pl.rings > 0 then
			pl.rings = 0
			P_PlayRinglossSound(pl.mo,pl)
			P_PlayerRingBurst(pl,pl.rings)
			P_KillMobj(pl.mo)
		end
		
		--TODO: CVar Toggle
		if pl.powers[pw_carry] == CR_PLAYER then
			pl.powers[pw_carry] = 0
		end
		
		--Scoot
		if not pl.scoottimer and (pl.cmd.buttons & BT_JUMP) then
			local angle = R_PointToAngle2(0,0, pl.cmd.forwardmove*FRACUNIT, -pl.cmd.sidemove*FRACUNIT)+pl.mo.angle
			if doCostCheck(pl,scootcost) then
				local speed = 4*FRACUNIT
				local zspeed = 5*FRACUNIT
				P_Thrust(pl.mo, angle, speed)
				pl.mo.momz = $+zspeed
				S_StartSound(pl.mo, sound_scoot)
				pl.scoottimer = TICRATE
			end
		end
		if pl.scoottimer and pl.scoottimer > 0 then
			pl.scoottimer = $-1
		end
	end
end

addHook("ShieldSpecial", function(pl)
	if pl.powers[pw_shield] == SH_ARMAGEDDON then
		local hit = false
		for pl2 in players.iterate do
			if not isPlayerActive(pl2) then continue end
       
			local dist = R_PointToDist2(pl.mo.x,pl.mo.y, pl2.mo.x, pl2.mo.y)
			if dist > armageddon_range then continue end
		
			if isIt(pl) then
				if not isIt(pl2) and not isFrozen(pl2) then
					hit = true
					local froze = doFreeze(pl.mo,pl2.mo)
					if not froze then
						P_DoPlayerPain(pl2,pl.mo)
						P_PlayerEmeraldBurst(pl2)
					end
				end
			else
				if isIt(pl2) then
					hit=true
					P_DoPlayerPain(pl2,pl.mo)
					continue
				end
				if isFrozen(pl2) then
					doUnfreeze(pl.mo,pl2.mo)
				end
			end
		end
		if hit then
			S_StartSound(pl.mo,sound_armause)
		end
	end
end)

local client = 0
addHook("ThinkFrame", function()
	if not isInGamemode() then return end
	local c,f,t = countPlayers()
	for i=0,31 do
		if not players[i] then continue end
       
        local pl=players[i]
        if not isPlayerActive(pl) then continue end

		--Remnants of Match replacement code.
		if pl.powers[pw_shield] == SH_PITY then
			P_RemoveShield(pl)
		end
		pl.weapondelay = UINT16_MAX
		
		--Ring Cap
		if pl.rings > maxrings then
			pl.rings = maxrings
		end
       
		--Tagger Logic
		if isIt(pl) then
			--IT! Icon
			local voffset = 5*FRACUNIT
			local mobj
			if not (pl.mo.eflags & MFE_VERTICALFLIP) then
				mobj = P_SpawnMobj(pl.mo.x, pl.mo.y, pl.mo.z + pl.mo.height + voffset, MT_TAG)
			else
				mobj = P_SpawnMobj(pl.mo.x, pl.mo.y, pl.mo.z - (mobjinfo[MT_TAG].height + voffset), MT_TAG)
				mobj.eflags = $1 | MFE_VERTICALFLIP
			end
			mobj.scale = (FRACUNIT*2)/3
			if client == pl then mobj.flags2 = $1 | MF2_SHADOW end
			mobj.tics = 1
       
			taggerAbility(pl)
       
			--It's possible for a frozen player to be assigned IT!
			if isFrozen(pl) then
				makeUnfrozen(pl)
			end
		else
		--Runner Logic
			if isFrozen(pl) then
				pl.mo.anim_duration = UINT16_MAX
				if pl.powers[pw_flashing] == 0 then pl.powers[pw_flashing] = 100 end

				local mobj = P_SpawnMobj(pl.mo.x, pl.mo.y, pl.mo.z, MT_TAG)
				mobj.sprite = SPR_CEMG
				if isSuperFrozen(pl) then
					mobj.frame = 2 | FF_TRANS50 | FF_FULLBRIGHT
				else
					mobj.frame = 3 | FF_TRANS50 | FF_FULLBRIGHT
				end
				mobj.tics = 1
				mobj.scale = FRACUNIT*3
       
				pl.powers[pw_nocontrol] = 32767
				pl.powers[pw_underwater] = UINT16_MAX
       
				pl.mo.state = S_PLAY_DEAD
			else
				if leveltime % (points_aliverate*TICRATE) == 0 then P_AddPlayerScore(pl, points_keepalive) end
			end
			
			runnerAbility(pl)
		end
		
		generalAbility(pl)
       
		--Brighten all players!
		pl.mo.frame = $ | FF_FULLBRIGHT

		if pl.playerstate == PST_DEAD and pl.deadtimer > 3*TICRATE then
			if isIt(pl) then
				print("\x85"+pl.name+"\x80 respawned!")
			else
				print("\x84"+pl.name+"\x80 respawned!")
			end
			G_DoReborn(i)
		end
			
		if isFrozen(pl) and leveltime < waittime then
			makeUnfrozen(pl)
		end
       
       	--Guide Controls
		if guide == 2 then
			if (pl.cmd.buttons & BT_ATTACK) or (pl.cmd.buttons & BT_SPIN) then
				COM_BufInsertText(pl, "FT_GUIDE 1")
			end
		end
	end

	if leveltime == waittime+gametime-timeclose then
       S_StartSound(nil, sound_timeclose)
       S_SpeedMusic(FRACUNIT+FRACUNIT/2)
       print(tostring(timeclose/TICRATE)+" seconds left!")
	end
		
	--IT assignment.
	if c > 0 and leveltime > waittime and (auto or leveltime == waittime+1) then
		local optedout = false --If too many peeps opt out, don't run the loops.
		while t < getTaggersForCount(c) and not optedout do
			optedout = makeRandomIt(leveltime > waittime+TICRATE)
			t=t+1
		end
       
		--Make sure there is always at least 2 runners!
		while t >= c-2 and c > 7 and not optedout do
			optedout = makeRandomNotIt(leveltime > waittime+TICRATE)
			t=t-1
		end
	end
       
	if leveltime == waittime+2 then
		print("The round has begun!")
       
		if t > 1 then
			local peeps = ""
			for pl in players.iterate do
				if not isIt(pl) then continue end
				if peeps == "" then
					peeps = "and " + pl.name
				else
					peeps = pl.name + ", " + $
				end
			end
			print("\x85"+peeps+" are now IT!")
		else
			for pl in players.iterate do
				if not isIt(pl) then continue end
				print("\x85"+pl.name+" is now IT!")
				break
			end
		end
	end
	
	--Win States
	if c > 1 and f >= c-t then
		print("All runners were frozen. Good Game!") G_ExitLevel()
	elseif leveltime > waittime+gametime then 
		print("Runners survived. Good Game!") G_ExitLevel()
	end
end)

--[[HUD]]
local function drawHeader(g,pl)
	if leveltime > waittime then
		local c,f,t = countPlayers()
		g.drawString(160-32,16, tostring(t), V_REDMAP, "center")
		g.drawString(160,16, tostring(c-(t+f)), V_BLUEMAP, "center")   
		g.drawString(160+32,16, tostring(f), V_SKYMAP, "center")
	end
	
	--[[Timer]]
	if leveltime > waittime then
		local color
		if leveltime >= (waittime+gametime)-timeclose and (leveltime % TICRATE > TICRATE/2) then
			color = V_REDMAP
		end
		g.drawString(160,0, "Time:", color or V_YELLOWMAP, "center")
		g.drawString(160,8, tostring((waittime+gametime-leveltime)/TICRATE), color, "center")
	end
end

local function drawWelcome(g,pl)
	local x=320/2
	local y=200/2
	local width=200
	local height=150
	g.drawFill(x-width/2, y-height/2, width,1,3)
	g.drawFill(x-width/2, y+height/2-1, width,1,3)
	g.drawFill(x-width/2, y-height/2+1, 1,height-2,3)
	g.drawFill(x+width/2-1, y-height/2+1, 1,height-2,3)
	g.drawFill(x-width/2+1, y-height/2+1, width-2,height-2,color_runner)
	g.drawString(x,y-(height/2-4), welcometitle, V_SKYMAP, "center")
	g.drawString(x-width/2+4,y-(height/2-16), welcomemsg, V_WHITEMAP, "left")
end

local tooltips={
	ability1={},
	ability2={},
	skin={},
	general={
		--{0, "Disable Tooltips", ">FT_GUIDE 0"},
	},
	idle={},
	it={
		{function() return tagcost end, "Freeze", "Touch Player"},
	},
	runner={
		{function() return tagcost end, "Unfreeze", "Touch Player"},
	},
	frozen={
		{-1, "Respawn", "Spin+Attack"},
		{function() return scootcost end, "Scoot", "Jump"},
	},
}
tooltips.ability1[CA_THOK] = {{0, "Super Jump", "Spindash+Jump"}}
tooltips.ability2[CA2_SPINDASH] = {{function() return armacost end, "Get Nuke", "Max Spin+Attack"}}

local function drawTooltip(g,pl,i,v)
	local tip = ""
	local cost = v[1]
	local name = v[2]
	local input = v[3]
	local color = V_YELLOWMAP
	if type(cost) == "function" then cost = cost(pl) end
	if cost ~= 0 then
		if cost == -1 then cost = max(pl.rings,1) end
		if pl.rings < cost then
			color = V_REDMAP
		end
		tip = "("+tostring(cost)+") "+$
	end
	tip = $+name+" - "+input
	g.drawString(320-5, 184-(i*8), tip, color, "right")
end

local function drawTooltips(g,pl)
	local i=0
	
	for k,v in pairs(tooltips["general"]) do
		drawTooltip(g,pl,i,v)
		i=i+1
	end
	
	if tooltips["ability1"][pl.charability] then
		for k,v in pairs(tooltips["ability1"][pl.charability]) do
			drawTooltip(g,pl,i,v)
			i=i+1
		end
	end
	if tooltips["ability2"][pl.charability2] then
		for k,v in pairs(tooltips["ability2"][pl.charability2]) do
			drawTooltip(g,pl,i,v)
			i=i+1
		end
	end
	if tooltips["skin"][pl.mo.skin] then
		for k,v in pairs(tooltips["skin"][pl.mo.skin]) do
			drawTooltip(g,pl,i,v)
			i=i+1
		end
	end

	local state = "idle"
	if leveltime > waittime then
		if isIt(pl) then
			state = "it"
		end
		if not isIt(pl) then
			state = "runner"
		end
		if isFrozen(pl) then
			state = "frozen"
		end
		
	end
	for k,v in pairs(tooltips[state]) do
		drawTooltip(g,pl,i,v)
		i=i+1
	end
end

hud.add(function(g,pl,cam)
	if not isInGamemode() then return end
	if pl.playerstate == PST_LIVE and isPlayerActive(pl) then
		client=pl
		
		local yo=0
		if not radar then yo=64 end
		--[[Status]]
		local str="RUNNER!"
		local c=V_BLUEMAP
		if leveltime < waittime then
			str="WAITING: "..(waittime-leveltime)/TICRATE
			c=nil
		elseif isIt(pl) then
			str="IT!" c=V_ORANGEMAP
		elseif isSuperFrozen(pl) then
			str="SUPER FROZEN" c=V_BLUEMAP
		elseif isFrozen(pl) then
			str="FROZEN" c=V_SKYMAP
		else
			local p,f,t = countPlayers()
			if f == (p-t)-1 then
				str="LAST ONE!" c=V_REDMAP
			end
		end

		g.drawString(8,120+yo, str, c)
       

		--[[Rings]]
		local c=V_YELLOWMAP
		if pl.rings < tagcost then c=V_REDMAP end
		if pl.rings >= 110 then c=V_SKYMAP end
       
		g.drawString(8,112+yo, "Power: "+tostring(pl.rings), c)

		
		--[[Emeralds]]
		if pl.powers[pw_emeralds] ~= 0 then
			g.drawString(8,104+yo, "Emeralds: "+tostring(getEmeralds(pl.powers[pw_emeralds])), V_YELLOWMAP)
		end
		
		--[[Radar]]
		if radar then
			local angle = (-cam.angle)-ANGLE_90
			local offsetx = 8
			local offsety = 128

			local framecolor = 3
		
			for pl2 in players.iterate do
				if pl2.playerstate ~= PST_LIVE or not isPlayerActive(pl2) then continue end
				local ox,oy = pl2.mo.x - pl.mo.x, pl2.mo.y - pl.mo.y
				local x = -(FixedMul(ox,cos(angle))-FixedMul(oy,sin(angle)))/radarscale
				local y =  (FixedMul(ox,sin(angle))+FixedMul(oy,cos(angle)))/radarscale
				
				--Phase out surviving teammate runners or teammate taggers as unimportant information.
				if (x > 31) or (x < -31) or (y > 31) or (y < -31) then
					if not isIt(pl)
					and not isIt(pl2)
					and not isFrozen(pl2) then
						continue
					end
					if isIt(pl) and isIt(pl2) then
						continue
					end
				end
				x = max(x,-31)
				x = min(x,31)
				y = max(y,-31)
				y = min(y,31)

				local blink = leveltime % 4 == 0
				local color = color_unassigned
				if not isIt(pl2) and leveltime > waittime then
					color = color_runner
		
					if isIt(pl) then
						framecolor = color_runner
					end
				end
				if isFrozen(pl2) then
					color = color_frozen
					if framecolor ~= color_it and not isIt(pl) then
						framecolor = color_frozen
					end
				end
				if isIt(pl2) then
					color = color_it
					if not isIt(pl) then
						if blink then
							color = color_itblink
						end
						framecolor = color_it
					end
				end
				g.drawFill(offsetx+30+x,offsety+30+y,4,4,color)
			end
		
			if not radarwarn then framecolor = 3 end
			
			g.drawFill(offsetx, offsety,	64,1,framecolor)
			g.drawFill(offsetx, offsety+63,	64,1,framecolor)
			g.drawFill(offsetx, offsety,	1,64,framecolor)
			g.drawFill(offsetx+63, offsety,	1,64,framecolor)
		end

		drawHeader(g,pl)
       	if guide == 1 then 
			drawTooltips(g,pl)
		end
		if guide == 2 then
			drawWelcome(g,pl)
		end
	end
end, "game")

local function drawItIcon(g,x,y,s)
	local IT = g.cachePatch(gfx_IT)
	g.drawScaled(x*FRACUNIT, y*FRACUNIT, s/2, IT)
end
local function drawFrzIcon(g,x,y,s)
	local FRZ = g.cachePatch(gfx_frz)
	g.drawScaled(x*FRACUNIT, y*FRACUNIT, s, FRZ, V_30TRANS)
end

hud.add(function(g)
	if not isInGamemode() then return end
	
	local playerlist = {}
	local c=0
	local p=0 --Seperate counter that counts all players. The score screen actually uses this value.
	for pl in players.iterate do
		p=p+1
		if pl.spectator then continue end
		table.insert(playerlist,{c,pl})
		c=c+1
	end
	table.sort(playerlist,function(a,b)
		return (a[2].score*32)+a[1] > (b[2].score*32)+b[1]
	end)
	
	--TAB Screen splits above 9 players.
	--At 21 players, the screen converts into 32-player version.
       
	local xo = 24
	local yo = 28
	if p > 9 then xo=16 end
	if p > 20 then xo=6 end
	local wrap = 9
	local wrdist = 16
	local scale = FRACUNIT
	if p > 20 then wrap=17 wrdist=9 scale=FRACUNIT/2 end
	for i=1,#playerlist do
		local pl2=playerlist[i][2]
		
		local x=(i-1)/wrap
		local y=(i-1)%wrap

		if i == wrap+1 and p > 20 then yo=yo+4 end
		
		if isIt(pl2) then
			drawItIcon(g,xo+(x*160), yo+(y*wrdist),scale)
		end
		if isFrozen(pl2) then
			drawFrzIcon(g,xo+(x*160)+wrdist, yo+(y*wrdist),scale)
		end
	end
       
	drawHeader(g,pl)
end, "scores")

--[[Misc Features]]
addHook("PlayerMsg", function(from,kind,to,msg)
	if isInGamemode() and kind == 1 then --Team-say!
		for pl in players.iterate do
			if isIt(from) == isIt(pl) then
				chatprintf(pl, "\3>>"+from.name+"<< (Team) "+msg, true)
			end
		end
		return true
	end
end)

addHook("MapThingSpawn", function(mobj)
	if not isInGamemode() then return end
	mobj.type = MT_RING_BOX
end,MT_RING_REDBOX)
addHook("MapThingSpawn", function(mobj)
	if not isInGamemode() then return end
	mobj.type = MT_RING_BOX
end,MT_RING_BLUEBOX)

addHook("PlayerSpawn", function(pl)
	if not isInGamemode() then return end
	if countPlayers() < 3 then return end --Prevent the game ending early on smaller games.
	makeFrozen(pl) --THis will be overriden by update.
end)

addHook("ShieldSpawn", function(pl)
	if not isInGamemode() then return end
	--Track how many rings the player has upon attract shield, so we can nerf it later.
	if pl.powers[pw_shield] == SH_ATTRACT then
		pl.preshrings = pl.rings
	end
end)

addHook("ShouldDamage", function(target, inflictor, source, damage, damagetype)
	if not isInGamemode() then return end
	if damagetype == DMG_INSTAKILL then
       return false
	end
end, MT_PLAYER)

--[[Console Commands]]
COM_AddCommand("IT", function(serv, name)
	if not name then
		CONS_Printf(serv,"No name given. Choosing a random player...")
		makeRandomIt(true)
	else
		for pl in players.iterate
			if string.lower(pl.name) == string.lower(name) then
				makeUnfrozen(pl)
				makeIt(pl,true)
				return
			end
		end
		CONS_Printf(serv,"Could not find player \""..name.."\"")
	end
end,1)
COM_AddCommand("NOT_IT", function(serv, name)
	if not name then
		CONS_Printf(serv,"No name given. Choosing a random player...")
		makeRandomNotIt(true)
	else
		for pl in players.iterate
			if string.lower(pl.name) == string.lower(name) then
				makeUnfrozen(pl)
				makeNotIt(pl,true)
				return
			end
		end
		CONS_Printf(serv,"Could not find player \""..name.."\"")
	end
end,1)

COM_AddCommand("FT_OPT",function(pl, arg)
	if not arg then
		CONS_Printf(pl,"0: Opting for both!")
		pl.opt = 0
		return
	end
	if string.lower(arg) == "it" or arg == "1" then
		CONS_Printf(pl,"1: Opting for IT!")
		print(pl.name,"opts for 1")
		pl.opt = 1
		return
	end
	if string.lower(arg) == "not_it" or arg == "2" then
		CONS_Printf(pl,"2: Opting for runner!")
		print(pl.name,"opts for 2")
		pl.opt = 2
		return
	end
end)
