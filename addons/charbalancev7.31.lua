-- Tails & Knuckles, Amy, Fang, Metal Sonic buff lua
-- Ïpèâeò âceì pyñcêoãoâopÿùèì!
-- Come join the best community at SRB2WorkShop.org!

-- ~
-- Freeslot stuff
-- ~
freeslot("MT_TWINDGUST", "S_TWINDGUST1", "S_TWINDGUST2", "S_TWINDGUST3", "S_TWINDGUST4", "S_TWINDGUST5", "MT_EXTRAKNUXEDBUDDY", "S_EXTRAKNUXEDBUDDY", "MT_SENTRY", "S_SENTRY")

mobjinfo[MT_TWINDGUST] =
{
	doomednum = -1,
	spawnstate = S_TWINDGUST1,
	spawnhealth = 10,
	radius = FRACUNIT*64,
	height = FRACUNIT*64,
	flags = MF_NOGRAVITY|MF_SHOOTABLE
}

mobjinfo[MT_LHRT].flags = $ & ~MF_NOBLOCKMAP

states[S_TWINDGUST1] =
{
	sprite = SPR_WIND,
	frame = 1,
	tics = 5,
	nextstate = S_TWINDGUST2
}
states[S_TWINDGUST2] =
{
	sprite = SPR_WIND,
	frame = FF_TRANS10|1,
	tics = 5,
	nextstate = S_TWINDGUST3
}
states[S_TWINDGUST3] =
{
	sprite = SPR_WIND,
	frame = FF_TRANS20|1,
	tics = 5,
	nextstate = S_TWINDGUST4
}
states[S_TWINDGUST4] =
{
	sprite = SPR_WIND,
	frame = FF_TRANS30|1,
	tics = 5,
	nextstate = S_TWINDGUST5
}
states[S_TWINDGUST5] =
{
	sprite = SPR_WIND,
	frame = FF_TRANS40|1,
	tics = 5,
	nextstate = S_NULL
}

mobjinfo[MT_EXTRAKNUXEDBUDDY] =
{
	doomednum = -1,
	spawnstate = S_EXTRAKNUXEDBUDDY,
	spawnhealth = 5000,
	radius = FRACUNIT*64,
	height = FRACUNIT*64,
	flags = MF_NOGRAVITY|MF_SHOOTABLE|MF_NOCLIPHEIGHT
}

states[S_EXTRAKNUXEDBUDDY] =
{
	sprite = SPR_PLAY,
	frame = SPR2_STND,
	tics = -1,
	nextstate = S_NULL
}

mobjinfo[MT_SENTRY] =
{
	doomednum = -1,
	spawnstate = S_SENTRY,
	spawnhealth = 10,
	radius = FRACUNIT*64,
	height = FRACUNIT*64,
	flags = MF_NOGRAVITY
}

states[S_SENTRY] =
{
	sprite = SPR_THOK,
	frame = 0,
	tics = -1,
	nextstate = S_SENTRY
}

-- ~
-- Other init stuff
-- ~

local function RemoveSentries(mo)
	if not (mo.sentry_table) return end
	for i=1,#mo.sentry_table
		local mobj = mo.sentry_table[i]
		if mobj == 0 continue end
		if not mobj.valid continue end
		P_RemoveMobj(mobj)
		mo.sentry_table[i] = 0
	end
end

local function CBReset(player)
	if not (player.mo) return end

	player.flythokcooldown = 0
	player.concentrating = 0
	player.concentrationtimer = 0
	player.frenzytimer = 0
	player.onfrenzy = 0
	player.mo.theothermomx = 0
	player.mo.theothermomy = 0
	player.mo.theothermomz = 0
	player.mo.theotherangle = 0
	player.mo.damaging = 0
	player.usehold = 0
	player.weaponhold = {0,0,0,0,0,0,0}
	player.weaponholdrmn = {0,0,0,0,0,0,0}
	player.notshot = 0
	player.rweapondelay = 0
	player.weapondelay2 = 0
	player.weapondelay3 = 0
	player.shotonce = 0
	player.delayshot = 0
	player.attacking = 0
	player.nattacking = 0
	player.usedelayshot = 0
	player.hearted = 0
	player.misdirection = 0
	player.cometrush = 0
	RemoveSentries(player.mo)
	player.mo.sentry_table = {0,0,0,0,0,0}
	player.sentryload = 0
	player.mo.loadshots = {{},{},{},{},{}}
	player.loadstart = 0
	player.loadstartangle = 0
	player.loadstartaiming = 0
	player.fanged = 0
	player.shotnum = 0
	player.owshotnum = 0
	player.normalspeed = skins[player.mo.skin].normalspeed
	player.acceleration = skins[player.mo.skin].acceleration
	player.accelstart = skins[player.mo.skin].accelstart
	player.actionspd = skins[player.mo.skin].actionspd
end

addHook("MobjSpawn", function(mo)
	mo.scale = 2*FRACUNIT
end, MT_TWINDGUST)

addHook("PlayerSpawn", function(player)
	if gamestate ~= GS_LEVEL return end
	CBReset(player)
end)

addHook("PlayerQuit", function(player)
	if gamestate ~= GS_LEVEL return end
	if not player.mo return end
	RemoveSentries(player.mo)
end)

addHook("MobjDeath", function(mo)
	if gamestate ~= GS_LEVEL return end
	RemoveSentries(mo)
end, MT_PLAYER)

rawset(_G,"charbalance",{})

charbalance.concentrationtimeout = 30*TICRATE
charbalance.concentrationmax = 30*TICRATE
charbalance.numbuddies = 8

charbalance.frenzytimeout = 30*TICRATE
charbalance.frenzytime = 10*TICRATE

charbalance.misdirectiontime = TICRATE
charbalance.misdirectiondelay = TICRATE
charbalance.cometrushtimeout = 10*TICRATE
charbalance.cometrushspeed = 60

charbalance.cv_charbalanceeverywhere = CV_RegisterVar({"charbalanceeverywhere", "No", CV_NETVAR, CV_YesNo})
charbalance.cv_charbalancehud = CV_RegisterVar({"charbalancehud", "On", CV_NETVAR, CV_OnOff})

local chosenweapons = {
	0, -- red ring
	WEP_AUTO,
	WEP_BOUNCE,
	WEP_SCATTER,
	WEP_GRENADE,
	WEP_EXPLODE,
	WEP_RAIL
}

local thingweapons = {
	MT_REDRING,
	MT_THROWNAUTOMATIC,
	MT_THROWNBOUNCE,
	MT_THROWNSCATTER,
	MT_THROWNGRENADE,
	MT_THROWNEXPLOSION,
	MT_REDRING
}

local flags2weapons = {
	0,
	MF2_AUTOMATIC,
	MF2_BOUNCERING,
	MF2_SCATTER,
	MF2_EXPLOSION,
	MF2_EXPLOSION,
	MF2_RAILRING
}

local powersweapons = {
	pw_infinityring,
	pw_automaticring,
	pw_bouncering,
	pw_scatterring,
	pw_grenadering,
	pw_explosionring,
	pw_railring
}

local soundsweapons = {
	sfx_wepfir,
	sfx_wepfir,
	sfx_bnce1,
	sfx_bnce2,
	sfx_wepfir,
	sfx_cannon,
	sfx_rail1
}

local delaysweapons = {
	TICRATE/4,
	2,
	TICRATE/4,
	(2*TICRATE)/3,
	TICRATE/3,
	(3*TICRATE)/2,
	(3*TICRATE)/2
}

local shotthinks = {
	MT_REDRING,
	MT_THROWNAUTOMATIC,
	MT_THROWNBOUNCE,
	MT_THROWNSCATTER,
	MT_THROWNGRENADE,
	MT_THROWNEXPLOSION,
	MT_THROWNINFINITY,
	MT_CORK,
	MT_LHRT
}

local targetoverride = 0
local sentryparm = 0

addHook("MobjSpawn", function(mo)
	if not mo return end
	if not (mo.flags & MF_MISSILE) or not mo.valid return end
	local allow = 0
	for i = 1, #shotthinks
		if mo.type == shotthinks[i]
			allow = 1
			break
		end
	end

	if not allow return end

	mo.fuse2 = 1
	mo.misdirecting = 0
	mo.lifetime = 0
end, MT_NULL)

-- ~
-- Convenient functions
-- ~

local function dotP(x1, y1, z1, x2, y2, z2)
	return FixedMul(x1,x2) + FixedMul(y1,y2) + FixedMul(z1,z2)
end

local function OnGround(mo)
	return not (P_IsObjectOnGround(mo) and mo.momz == 0)
end

local function Ally(p1,p2)
	if p1 == p2
		return true
	end

	if G_TagGametype()
		return (p1.pflags & PF_TAGIT) == (p2.pflags & PF_TAGIT)
	elseif G_GametypeHasTeams()
		return (p1.ctfteam == p2.ctfteam)
	elseif G_RingSlingerGametype()
		return false
	elseif G_PlatformGametype()
		return true
	end

	return true
end

local function P_SuperDamage(player,inflictor,source)
	local fallbackspeed = 0
	if (player.mo.eflags & MFE_VERTICALFLIP)
		player.mo.z = $-1
	else
		player.mo.z = $+1
	end
	if (player.mo.eflags & MFE_UNDERWATER)
		P_SetObjectMomZ(player.mo, FixedDiv(10511*FRACUNIT,2600*FRACUNIT),false)
	else
		P_SetObjectMomZ(player.mo, FixedDiv(69*FRACUNIT,10*FRACUNIT),false)
	end

	local ang = R_PointToAngle2(inflictor.x,inflictor.y,player.mo.x,player.mo.y)

	if (inflictor.flags2 & MF2_SCATTER and source)
		local dist = P_AproxDistance(P_AproxDistance(source.x-player.mo.x,source.y-player.mo.y),source.z-player.mo.z)
		dist = FixedMul(128*FRACUNIT, inflictor.scale) - $/4
		dist = max($,FixedMul(4*FRACUNIT,inflictor.scale))
		fallbackspeed = dist
	elseif (inflictor.flags2 & MF2_EXPLOSION)
		if (inflictor.flags2 & MF2_RAILRING)
			fallbackspeed = FixedMul(28*FRACUNIT, inflictor.scale)
		else
			fallbackspeed = FixedMul(20*FRACUNIT, inflictor.scale)
		end
	elseif (inflictor.flags2 & MF2_RAILRING)
		fallbackspeed = FixedMul(16*FRACUNIT, inflictor.scale)
	else
		fallbackspeed = FixedMul(4*FRACUNIT, inflictor.scale)
	end

	P_InstaThrust(player.mo, ang, fallbackspeed)
	player.mo.state = S_PLAY_STUN
	P_ResetPlayer(player)
	if player.timeshit ~= UINT8_MAX
		player.timeshit = 1+$
	end
end

local function ReadyMisdirect(mo)
	mo.misdirecting = 1
	local speed = mo.info.speed
	local tg = mo.target
	local pspeed = FixedSqrt(FixedMul(tg.momx,tg.momx)+FixedMul(tg.momy,tg.momy)+FixedMul(tg.momz,tg.momz))
	if pspeed == 0
		mo.dmomx, mo.dmomy, mo.dmomz = mo.momx, mo.momy, mo.momz
	else
		mo.dmomx, mo.dmomy, mo.dmomz = FixedMul(FixedDiv(tg.momx,pspeed),speed), FixedMul(FixedDiv(tg.momy,pspeed),speed), FixedMul(FixedDiv(tg.momz,pspeed),speed)
	end
	mo.omomx, mo.omomy, mo.omomz = mo.momx, mo.momy, mo.momz
end

local function Misdirect(mo)
	local xl, yl, zl = mo.omomx-mo.dmomx, mo.omomy-mo.dmomy, mo.omomz-mo.dmomz
	local mdt = charbalance.misdirectiontime
	local tc = mo.lifetime - charbalance.misdirectiondelay
	if (tc > mdt)
		tc = mdt
	elseif (tc < 0)
		tc = 0
	end
	mo.momx, mo.momy, mo.momz = mo.omomx-xl*tc/mdt, mo.omomy-yl*tc/mdt, mo.omomz-zl*tc/mdt
end

local function P_DrainWeaponAmmo(player, power)
	player.powers[power] = $ - 1
	if (power == pw_infinityring)
		return
	end

	if (player.rings < 1)
		player.ammoremovalweapon = player.currentweapon
		player.ammoremovaltimer = ammoremovaltics

		if (player.powers[power] > 0)
			player.powers[power] = $ - 1
			player.ammoremoval = 2
		else
			player.ammoremoval = 1
		end
	else
		player.rings = $ - 1
	end
end

local function P_CheckMissileSpawn(th)
	local newx = th.x
	local newy = th.y
	local newz = th.z
	if (!(th.flags & MF_GRENADEBOUNCE))
		newx = $ + (th.momx/2)
		newy = $ + (th.momy/2)
		newz = $ + (th.momz/2)
	end

	th.z = newz
	if (not P_TryMove(th, newx, newy))
		P_ExplodeMissile(th)
		return false
	end

	return true
end

local function MakeTrail(mo, dt, app)
	if mo.target
		if not mo.target.valid
			return nil
		end
	else
		return nil
	end
	if dt == 0
		return nil
	end

	local type = mo.type
	local trail = P_SpawnMobj(mo.x, mo.y, mo.z, mo.type)
	trail.trail = 1
	trail.angle = mo.angle
	trail.target = mo.target
	trail.flags = $ | MF_NOSECTOR | MF_NOBLOCKMAP | MF_NOGRAVITY
	if trail.type == MT_LHRT
		trail.extravalue2 = 1*FRACUNIT
	end
	trail.appearcool = app
	trail.simomx, trail.simomy, trail.simomz = (128-P_RandomByte())<<6, (128-P_RandomByte())<<6, P_RandomByte()<<8
	trail.nospawn = 1
	trail.destroytimer = dt
	if trail.type == MT_REDRING and mo.target.player
		P_ColorTeamMissile(trail, mo.target.player)
	end
	return trail
end

local function DoRail(mo)
	local amy = 0
	local hasplayer = 0
	if (mo.target)
		if (mo.target.valid and mo.target.player)
			if (mo.target.skin == "amy")
				amy = 1
			end
			hasplayer = 1
		end
	end
	for i = 0,256
		if not (mo.valid) return end
		if (i & 1)
			P_SpawnMobj(mo.x, mo.y, mo.z, MT_SPARK)
		end
		if (i % 4 == 0 and amy)
			MakeTrail(mo, TICRATE, TICRATE/2+i/3)
		end
		if hasplayer
			if mo.misdirecting
				Misdirect(mo)
			end
		end
		if (P_RailThinker(mo)) break end
		mo.lifetime = $ + 1
	end
	if (mo.valid)
		S_StartSound(mo, sfx_rail2)
	end
end

local function ShotWrapper(source, shot, ang_h, ang_v)
	if (shot)
		if not (shot.valid)
			return nil
		end
	else
		return nil
	end

	local myplayer = 0
	local delayshot = 0
	if shot.target
		if shot.target.player
			myplayer = shot.target.player
		end
	end
	if myplayer
		if myplayer.delayshot and myplayer.usedelayshot
			delayshot = 1
		end
	end

	if source
		if source.type == MT_SENTRY
			shot.fromsentry = 1
		end
	end

	for i = 1, NUM_WEAPONS
		if (shot.type == thingweapons[i])
			shot.flags2 = $ | flags2weapons[i]
			break
		end
	end

	if (shot.type == MT_THROWNBOUNCE)
		shot.fuse = TICRATE*5
	elseif (shot.type == MT_THROWNGRENADE)
		shot.fuse = shot.info.reactiontime
	end
	if (shot.flags2 & MF2_RAILRING and not delayshot)
		S_StartSound(shot.target, sfx_rail1)
		DoRail(shot)
		return nil
	end

	//shot.flags = $ | MF_SHOOTABLE
	shot.flags = $ & ~MF_NOBLOCKMAP

	if (shot.target)
		if (shot.target.player)
			if shot.type == MT_REDRING and G_GametypeHasTeams()
				P_ColorTeamMissile(shot, shot.target.player)
			end

			if shot.target.player.misdirection and not shot.fromsentry
				ReadyMisdirect(shot)
			end
		end
	end

	return shot
end

local function P_SMMAngle(source, type, angle, vangle, flags2)
	local x = source.x
	local y = source.y
	local z = source.z + source.height/3
	local flip = source.eflags & MFE_VERTICALFLIP
	if (flip)
		z = $ + source.height/3 - FixedMul(mobjinfo[type].height, source.scale)
	end
	local th = P_SpawnMobj(x,y,z,type)
	if (flip)
		th.flags2 = $ | MF2_OBJECTFLIP
	end
	th.destscale = source.scale
	P_SetScale(th, source.scale)
	th.flags2 = $ | flags2
	local mysound = th.info.seesound
	if (mysound and not (th.flags2 & MF2_RAILRING))
		S_StartSound(source,mysound)
	end
	if targetoverride == 0
		th.target = source
	else
		th.target = targetoverride
	end
	local speed = th.info.speed
	if (source.player)
		if (source.player.charability == CA_FLY)
			speed = FixedMul($,3*FRACUNIT/2)
		end
	end
	th.angle = angle
	th.momx = FixedMul(speed,cos(angle))
	th.momy = FixedMul(speed,sin(angle))
	th.momx = FixedMul($,cos(vangle))
	th.momy = FixedMul($,cos(vangle))
	th.momz = FixedMul(speed,sin(vangle))

	th.momx,th.momy,th.momz = FixedMul($1,th.scale),FixedMul($2,th.scale),FixedMul($3,th.scale)

	ShotWrapper(source, th, angle, vangle)

	if th
		if th.valid
			--P_CheckMissileSpawn(th)
		end
	end
	return th
end

local function P_SMDblAngle(source, type, hangle, vangle, flags2)
	if not source return nil end
	if not source.valid return nil end
	local th = P_SMMAngle(source, type, hangle, vangle, flags2)
	if not th return nil end
	if not th.valid return nil end
	if not source return nil end
	if not source.valid return nil end

	if not targetoverride
	if (source.target) and not (source.player)
		th.target = source.target
	else
		th.target = source
	end
	end

	return th
end

local function P_CheckFullPosition(mo)
	local newmo = P_SMMAngle(mo, MT_NAMECHECK, 0, 0, 0)
	if not newmo
		return false
	end
	if not newmo.valid
		return false
	end
	P_RemoveMobj(newmo)
	return true
end

local function RealShots(player, power, shots)
	local count = 0
	for i = 0,shots-1
		if (player.powers[power] == 0) break end
		count = $ + 1
		P_DrainWeaponAmmo(player, power)
	end
	return count
end

local function SaveWeapons(player)
	player.temp = {}
	player.temp[1] = player.rings
	for i = 1,#powersweapons
		player.temp[i+1] = player.powers[powersweapons[i]]
	end
end

local function LoadWeapons(player)
	if not player.temp return end
	player.rings = player.temp[1]
	for i = 1,#powersweapons
		player.powers[powersweapons[i]] = player.temp[i+1]
	end
end

local function CheckLoadAmmo(player)
	//SaveWeapons(player)
	if #player.mo.loadshots[2] == 0
		return false
	end
	local hoff = player.mo.angle - player.mo.loadshots[3][1]
	local voff = player.aiming - player.mo.loadshots[4][1]
	local ammotolose = {0,0,0,0,0,0,0}
	for i = 1,#player.mo.loadshots[2]
		local type = player.mo.loadshots[2][i]
		for j = 1,#thingweapons-1
			if type != thingweapons[j] continue end

			ammotolose[j] = $ + 1
		end
		if type == MT_THROWNINFINITY
			ammotolose[1] = $ + 1
		elseif type == MT_REDRING and #player.mo.loadshots[5][i] == 1
			if player.mo.loadshots[5][i][1] != MF2_RAILRING continue end
			ammotolose[#thingweapons] = $ + 1
		end
		//player.mo.loadshots[3][i] = $ + hoff
		//player.mo.loadshots[4][i] = $ + voff
	end
	local infshots = 0
	if player.powers[pw_infinityring]
		infshots = RealShots(player,powersweapons[1],ammotolose[1])
		ammotolose[1] = $ - infshots
	end
	if ammotolose[1] > 0
		if ammotolose[1] > player.rings
			//LoadWeapons(player)
			return false
		end
		player.rings = $ - ammotolose[1]
		ammotolose[1] = 0
	end

	for i = 1,#player.mo.loadshots[2]
		local type = player.mo.loadshots[2][i]
		if type != MT_REDRING and type != MT_THROWNINFINITY
			continue
		end
		if #player.mo.loadshots[5][i] == 1
			if player.mo.loadshots[5][i][1] == MF2_RAILRING
				continue
			end
		end
		if type == MT_THROWNINFINITY
			if infshots > 0
				infshots = $ - 1
			else
				player.mo.loadshots[2][i] = MT_REDRING
			end
		else
			if infshots > 0
				infshots = $ - 1
				player.mo.loadshots[2][i] = MT_THROWNINFINITY
			end
		end
	end
	for i = 2,#powersweapons
		local shots = RealShots(player,powersweapons[i],ammotolose[i])
		if shots < ammotolose[i]
			return false
		end
	end
	//LoadWeapons(player)
	return true
end

local function AppropriateGametype()
	if not (G_RingSlingerGametype())
		if not (charbalance.cv_charbalanceeverywhere.value)
			return false -- Charbalance only in ringslinger gametypes unless forced...
		end
	end
	return true
end

local function CanReflect(thing, tmthing)
	if (thing == nil or tmthing == nil)
		return false
	end
	if not (thing.valid and tmthing.valid)
		return false
	end
	if not (tmthing.flags & MF_MISSILE)
		return false
	end
	if (tmthing.flags & MF_FIRE)
		return false
	end
	if (tmthing.type == MT_CORK)
		return false -- Fang cork trumps over
	end
	if (tmthing.type == MT_LHRT)
		return false
	end

	return true
end

local function KnuxStopConcentration(mo)
	if not mo.player
		return
	end

	mo.player.concentrating = 0
	mo.player.concentrationtimer = 0
	mo.player.weapondelay = TICRATE
	S_StartSound(thing, sfx_s3k46)
end

local function KnuxReflectMissile(ref_target, ref_inflictor, ref_source)
	if (CanReflect(ref_source, ref_target) == false)
		return false
	end
	if (ref_inflictor.z + ref_inflictor.height < ref_target.z or ref_inflictor.z > ref_target.z + ref_target.height)
		return false
	end
	if (ref_source.skin ~= "knuckles" or ref_source.player == nil)
		return false -- Not a valid Knux, sorry
	end
	if not ((ref_source.player.pflags & PF_GLIDING) and ref_source.player.glidetime < TICRATE-1)
		return false -- Knux can deflect projectiles only the first second when gliding
	end
	if (ref_source.player.powers[pw_super])
		return -- Don't overpower super even more!
	end
	if (ref_target.target == ref_source) -- This projectile is already on my side!
		return false
	end
	if (ref_target.fuse2 and not (ref_target.flags2 & MF2_RAILRING))
		P_KillMobj(ref_target)
		return true
	end
	-- Commented out because it's not possible to check cv_friendlyfire's value from Lua! That sucks! =( (Latest version as of writing : 2.1.19)
	-- Thinking about it the other way, could you increase your firepower by making a teammate shoot at you on purpose so you can redirect their shots at an enemy?
	--if (ref_target.target.player and G_GametypeHasTeams() and cv_friendlyfire.value == 0)
		--if (ref_target.target.player.ctfteam == ref_source.player.ctfteam)
			--return false -- Don't react to a teammate's projectiles
		--end
	--end

	local angle = R_PointToAngle2(ref_inflictor.x, ref_inflictor.y, ref_target.x, ref_target.y)
	local anglediff = abs(AngleFixed(ref_inflictor.angle) - AngleFixed(angle))

	local fulldist = P_AproxDistance(P_AproxDistance(ref_target.momx, ref_target.momy), ref_target.momz)
	local force = fulldist

	local zangle = R_PointToAngle2(0, (ref_inflictor.z+ref_inflictor.height/2)/3, fulldist, (ref_target.z+ref_target.height/2)/3)

	ref_target.target = ref_source
	ref_target.tracer = nil
	if not (anglediff < 90*FRACUNIT or anglediff > 270*FRACUNIT) -- Missile hit Knux from behind
		ref_target.momx = FixedMul(force, cos(angle))
		ref_target.momy = FixedMul(force, sin(angle))
		ref_target.momz = FixedMul(force, sin(zangle))
	else
		ref_target.momx = FixedMul(force, cos(ref_source.angle))
		ref_target.momy = FixedMul(force, sin(ref_source.angle))
		ref_target.momz = FixedMul(force, sin(ref_source.player.aiming))
	end

	if (ref_inflictor == ref_source)
		ref_source.theothermomx = $1 - FixedMul(force/8, cos(angle))
		ref_source.theothermomy = $1 - FixedMul(force/8, sin(angle))
		ref_source.theothermomz = $1 - FixedMul(force/8, sin(zangle))
	end

	if (ref_target.target.player)
		P_ColorTeamMissile(ref_target, ref_target.target.player)
	end
	S_StartSound(ref_target, sfx_s3k8b)

	return true
end

local function IsDeflecting(mo)
	if not (mo.player)
		return false
	end

	if not ((mo.player.pflags & PF_GLIDING) and (mo.player.glidetime < TICRATE-1 or (#mo.buddy_table and mo.player.glidetime < 3*TICRATE/2-1)))
		return false
	end

	return true
end

local function DoKnuxSFX(mo)
	if not (mo.player)
		return
	end

	if not (IsDeflecting(mo))
		return
	end

	if ((mo.player.glidetime % 5) == 0)
		S_StartSound(mo, sfx_s3k9a)
	end
end

local function DoNiceScatter(mo, vangle, mommul)
	local oldflags = mo.flags
	mo.flags = $ | MF_NOCLIP | MF_NOCLIPHEIGHT
	if vangle == nil
		vangle = mo.player.aiming
	end
	if mommul == nil
		mommul = 100;
	end
	local shot = P_SMMAngle(mo, MT_THROWNSCATTER, mo.angle, vangle, MF2_SCATTER)
	shot.momx, shot.momy, shot.momz = $1 * mommul / 100, $2 * mommul / 100, $3 * mommul / 100
	shot = P_SMMAngle(mo, MT_THROWNSCATTER, mo.angle+ANG2, vangle, MF2_SCATTER)
	shot.momx, shot.momy, shot.momz = $1 * mommul / 100, $2 * mommul / 100, $3 * mommul / 100
	shot = P_SMMAngle(mo, MT_THROWNSCATTER, mo.angle-ANG2, vangle, MF2_SCATTER)
	shot.momx, shot.momy, shot.momz = $1 * mommul / 100, $2 * mommul / 100, $3 * mommul / 100
	local mul = FixedMul(12*FRACUNIT, mo.scale)
	mo.z = $ + mul
	vangle = $ + ANG1
	shot = P_SMMAngle(mo, MT_THROWNSCATTER, mo.angle, vangle, MF2_SCATTER)
	shot.momx, shot.momy, shot.momz = $1 * mommul / 100, $2 * mommul / 100, $3 * mommul / 100
	mo.z = $ - mul*2
	vangle = $ - ANG2
	shot = P_SMMAngle(mo, MT_THROWNSCATTER, mo.angle, vangle, MF2_SCATTER)
	shot.momx, shot.momy, shot.momz = $1 * mommul / 100, $2 * mommul / 100, $3 * mommul / 100
	mo.z = $ + mul
	vangle = $ + ANG1
	mo.flags = oldflags
end

local function BulkShot(mo, shottype, flags2, num, radius)
	local angle,aiming = mo.angle,mo.player.aiming
	for i = 0,num-1
		local deviationh = FixedMul(radius, P_RandomFixed()) - radius/2
		local deviationv = FixedMul(radius, P_RandomFixed()) - radius/2
		local ang_h = mo.angle+deviationh
		local ang_v = 0
		local mommul = 100 + P_RandomByte() % 50
		if (mo.player)
			ang_v = mo.player.aiming
		-- The lines below mark an easier way to do this, but I wanted an excuse to do vector math...
		--elseif (mo.target.player)
		--	ang_v = mo.target.player.aiming
		else
			local dist = FixedSqrt(FixedMul(mo.momx,mo.momx) + FixedMul(mo.momy,mo.momy) + FixedMul(mo.momz,mo.momz))
			local dot = dotP(mo.momx, mo.momy, mo.momz, 0, 0, 1)
			ang_v = dot*ANG1*2/3
		end
		ang_v = $ + deviationv
		
		if (shottype == MT_THROWNSCATTER)
			mo.angle = ang_h
			mo.player.aiming = ang_v
			DoNiceScatter(mo, mo.player.aiming, mommul)
		else
			local shot = P_SMDblAngle(mo, shottype, ang_h, ang_v, flags2)
			if (shot)
			if (shot.valid)
				shot.momx, shot.momy, shot.momz = $1 * mommul / 100, $2 * mommul / 100, $3 * mommul / 100
			end
			end
		end
	end
	mo.angle = angle
	mo.player.aiming = aiming
end

local function SentryAddLoad(mo, weapon)
	if mo.player.loadstart == 0
		mo.player.loadstart = mo.player.realtime-1
		mo.player.loadstartangle = mo.angle
		mo.player.loadstartaiming = mo.player.aiming
		mo.loadshots = {{},{},{},{},{}}
	end

	local myringthing = thingweapons[weapon+1]
	if weapon == 0 and mo.player.currentweapon == 0 and mo.player.powers[pw_infinityring]
		myringthing = MT_THROWNINFINITY
	end

	table.insert(mo.loadshots[1],(mo.player.realtime-mo.player.loadstart)*2)
	table.insert(mo.loadshots[2],myringthing)
	table.insert(mo.loadshots[3],mo.angle)
	table.insert(mo.loadshots[4],mo.player.aiming)
	if weapon == WEP_RAIL
		mo.loadshots[5][#mo.loadshots[1]] = {MF2_RAILRING}
	else
		mo.loadshots[5][#mo.loadshots[1]] = {}
	end
	S_StartSound(mo, soundsweapons[weapon+1])
end

local function ShootRail(mo)
	if not mo.player.powers[pw_railring]
		return nil
	end

	local mydelay = delaysweapons[WEP_RAIL+1]
	local rail = nil
	if mo.player.delayshot and mo.player.usedelayshot
		rail = P_SMDblAngle(mo, MT_REDRING, mo.angle, mo.player.aiming, MF2_RAILRING)
		if (rail)
		if (rail.valid)
			S_StartSound(mo, sfx_rail1)
			rail.flags2 = $ | MF2_AXIS
		end
		end
	elseif mo.player.sentryload
		mydelay = $ / 2
		SentryAddLoad(mo, WEP_RAIL)
	else
		P_SMDblAngle(mo, MT_REDRING, mo.angle, mo.player.aiming, MF2_RAILRING)
		//ShotWrapper(mo, rail, mo.angle, mo.player.aiming)
	end

	mo.player.rweapondelay = mydelay
	P_DrainWeaponAmmo(mo.player, pw_railring)

	return rail
end

local function ShootScatter(mo)
	if not mo.player.powers[pw_scatterring]
		return nil
	end

	local mydelay = delaysweapons[WEP_SCATTER+1]

	if mo.player.sentryload > 0
		mydelay = $ / 2
		SentryAddLoad(mo, WEP_SCATTER)
	else
		DoNiceScatter(mo)
	end
	P_DrainWeaponAmmo(mo.player, pw_scatterring)
	mo.player.rweapondelay = mydelay

	return scat
end

local function FangOffsetShot(player, shot)
	local mult = 1
	if (player.mo.eflags & MFE_VERTICALFLIP)
		mult = -1
	end

	local offset = FixedMul(60*FRACUNIT*mult, player.mo.scale)
	local add = FixedMul(offset,-cos(player.mo.angle))
	add = FixedMul($,sin(player.aiming))
	local x = shot.x + add
	add = FixedMul(offset,-sin(player.mo.angle))
	add = FixedMul($,sin(player.aiming))
	local y = shot.y + add
	local z = shot.z + FixedMul(offset,cos(player.aiming))
	P_TeleportMove(shot,x,y,z)
end

local function KnuxConcentrationFire(mo)
	local shots = 60
	local shotsfor = {60, 80, 20, 20, 20, 10, 10}
	if (mo.player.currentweapon == 0)
		if mo.player.powers[pw_infinityring]
			shots = RealShots(mo.player, powersweapons[1], shotsfor[1])
			BulkShot(mo, MT_THROWNINFINITY, 0, shots/2, ANG1*10, 1)
			shots = shotsfor[1] - $
		end
		if (mo.player.rings < shots)
			shots = mo.player.rings
		end
		BulkShot(mo, MT_REDRING, 0, shots, ANG1*10)
		P_GivePlayerRings(mo.player, -shots)
	end
	for i = 2, 7
		if (mo.player.currentweapon != chosenweapons[i]) continue end

		shots = RealShots(mo.player, powersweapons[i], shotsfor[i])
		local cone = ANG1*10
		if i == 7
			cone = ANG1*5
		end
		BulkShot(mo, thingweapons[i], flags2weapons[i], shots, cone)
		break
	end
	KnuxStopConcentration(mo)
end

local function Ready2Fire(player)
	if not player.mo return false end
	if not player.mo.valid
		return false
	end

	local realweapon = player.currentweapon
	if player.nattacking
		realweapon = 0
	end

	if (player.shotonce and realweapon != WEP_AUTO and (player.sentryload == 0 or player.nattacking)) or player.climbing or (G_TagGametype() and not (player.pflags & PF_TAGIT))
		return false
	end

	if player.mo.tracer
		if player.powers[pw_carry] == CR_ZOOMTUBE
			return false
		end
	end

	if not (G_RingSlingerGametype())
		return false
	end

	if player.playerstate == PST_DEAD
		return false
	end

	if player.rweapondelay == 0
		return true
	end

	if player.mo.skin == "fang"
		if player.weapondelay2 == 0
			return true
		end
		if player.weapondelay3 == 0
			return true
		end
	end
	return false
end

local function RingFire(mo,weapon)
	local shot
	local myringthing = thingweapons[weapon+1]
	if weapon == WEP_SCATTER
		return ShootScatter(mo)
	elseif weapon == WEP_RAIL
		return ShootRail(mo)
	elseif weapon != 0
		if not mo.player.powers[powersweapons[weapon+1]]
			return nil
		end
		P_DrainWeaponAmmo(mo.player, powersweapons[weapon+1])
	else
		if mo.player.currentweapon != 0
			if not mo.player.rings
				return nil
			end
			mo.player.rings = $ - 1
		else
			if mo.player.powers[pw_infinityring]
				myringthing = MT_THROWNINFINITY
				mo.player.powers[pw_infinityring] = $ - 1
			else
				if not mo.player.rings
					return nil
				end
				mo.player.rings = $ - 1
			end
		end
	end
	shot = P_SPMAngle(mo, myringthing, mo.angle, 1, flags2weapons[weapon+1])
	ShotWrapper(mo, shot, mo.angle, mo.player.aiming)
	return shot
end

local function DoFire(player)
	if not player.mo return false end
	if not player.mo.valid
		return false
	end
	
	local realweapon = player.currentweapon
	if player.nattacking
		realweapon = 0
	end

	if realweapon == 0 and player.rings == 0
	if not player.powers[pw_infinityring]
		return false
	end
	end

	local wdelay = delaysweapons[realweapon+1]
	local offsetfire = 0

	if player.hearted > 0
		wdelay = $ * 2
	end

	if player.mo.skin == "knuckles"
		wdelay = ($*2)/3
	elseif player.mo.skin == "fang"
		if wdelay >= TICRATE/3
		if player.onfrenzy
			wdelay = $ / 2
		end
		if player.rweapondelay > 0
			if player.weapondelay2 == 0
				player.rweapondelay = 0
				player.weapondelay2 = wdelay*2
			elseif player.weapondelay3 == 0
				player.rweapondelay = 0
				player.weapondelay3 = wdelay*4
			end
		end
		elseif player.rweapondelay == 0
			if player.onfrenzy
				SaveWeapons(player)
			end
			RingFire(player.mo,realweapon)
			offsetfire = 1
			if player.onfrenzy
				LoadWeapons(player)
			end
		end
	end

	if player.rweapondelay == 0
		if player.sentryload > 0 and not player.nattacking
			wdelay = $ / 2
			SentryAddLoad(player.mo, realweapon)
			if realweapon == 0 and not player.powers[pw_infinityring]
				player.rings = $ - 1
			else
				P_DrainWeaponAmmo(player, powersweapons[realweapon+1])
			end
		else
			if (player.concentrating)
				KnuxConcentrationFire(player.mo)
				wdelay = $ * 3 + TICRATE/2
			else
				local shot = RingFire(player.mo,realweapon)
				if offsetfire == 1 and shot
				if shot.valid
					FangOffsetShot(player, shot)
				end
				end
				if (#player.mo.buddy_table)
					local candidates = {}
					for i, mobj in ipairs(player.mo.buddy_table)
						if not mobj.valid
							continue
						end
						if not P_CheckFullPosition(mobj)
							continue
						end

						table.insert(candidates, mobj)
					end
					local myringthing = thingweapons[realweapon+1]
					if shot
					if shot.valid and realweapon == 0
						if shot.type == MT_THROWNINFINITY
							myringthing = shot.type
						end
					end
					end
					if (#candidates and (player.owshotnum % 3 == 0))
						local rand = P_RandomByte() % (#candidates)
						local cm = candidates[rand+1]
						targetoverride = player.mo
						local fsin,fcos = 0,0
						if myringthing == MT_THROWNSCATTER
							local angm = ANG1/8*360
							local mycos = cos((cm.count-1)*angm)
							local mysin = sin((cm.count-1)*angm)
							fcos = FixedMul(ANG1*3,mycos)
							fsin = FixedMul(ANG1*3,mysin)
							P_SMDblAngle(cm, myringthing, player.mo.angle+fcos*3, player.aiming+fsin*3, flags2weapons[realweapon+1])
							P_SMDblAngle(cm, myringthing, player.mo.angle+fcos*2, player.aiming+fsin*2, flags2weapons[realweapon+1])
						end
						P_SMDblAngle(cm, myringthing, player.mo.angle+fcos, player.aiming+fsin, flags2weapons[realweapon+1])
						targetoverride = 0
					end
				end
			end
			player.shotnum = $ + 1
			player.owshotnum = $ + 1
		end
		player.rweapondelay = wdelay
		player.shotonce = 1
		return true
	end

	return false
end

-- ~
-- Hook functions
-- ~

local function ShotThink(mo)
	if not (mo.flags & MF_MISSILE)
		return
	end

	local allow = 0

	for i = 1, #shotthinks
		if mo.type == shotthinks[i]
			allow = 1
			break
		end
	end

	if not allow
		return
	end

	if not mo.valid
		return
	end

	if not AppropriateGametype()
		return
	end

	local hasplayer = 0
	if mo.target
		if mo.target.valid and mo.target.player
			hasplayer = 1
		end
	end

	if (mo.trail and mo.type == MT_THROWNGRENADE)
		mo.fuse = TICRATE-1
	end

	if (hasplayer)
		if mo.target.player.nattacking
			mo.normalfired = 1
		end
	end

	if (mo.appearcool ~= nil)
		if (mo.appearcool > 0)
			mo.appearcool = $ - 1
			if (mo.appearcool == 0)
				mo.momx, mo.momy, mo.momz = mo.simomx, mo.simomy, mo.simomz
				mo.flags = $ & ~(MF_NOSECTOR | MF_NOBLOCKMAP)
				if (mo.flags2 & MF2_AXIS)
					mo.flags2 = $ & ~MF2_AXIS
					mo.flags2 = $ | MF2_RAILRING
				end
				
				if (mo.flags2 & MF2_RAILRING)
					DoRail(mo)
					return
				end
			end
			return true
		else
			if (mo.destroytimer ~= nil)
				if (mo.destroytimer == 0)
					P_RemoveMobj(mo)
					return
				else
					mo.destroytimer = $ - 1
				end
			end
		end
	else
		if not hasplayer return end
		if (mo.nospawn) return end

		local dt = TICRATE/9
		local interval = TICRATE/12
		if mo.type == MT_THROWNAUTOMATIC
			dt = TICRATE/18
		elseif mo.type == MT_THROWNBOUNCE
			dt = 0
		elseif mo.type == MT_THROWNSCATTER
			dt = TICRATE/18
		elseif mo.type == MT_THROWNGRENADE
			dt = TICRATE/15
		elseif mo.type == MT_LHRT
			dt = TICRATE*5/6
			interval = TICRATE/4
		end
		if (mo.target.skin == "amy" and (leveltime % interval) == 0) and (mo.fuse or (mo.type != MT_LHRT and mo.type != MT_THROWNGRENADE))
			MakeTrail(mo, dt, 2)
		end

		if (mo.target.player.delayshot and mo.target.player.usedelayshot and not mo.fromsentry and not mo.deflected)
			mo.simomx, mo.simomy, mo.simomz = mo.momx, mo.momy, mo.momz
			mo.momx, mo.momy, mo.momz = 0,0,0
			mo.flags = $ | MF_NOSECTOR | MF_NOBLOCKMAP
			mo.appearcool = mo.target.player.delayshot
		end
	end

	if mo.type == MT_CORK
		if mo.lifetime == 4
			mo.flags = $ & ~MF_NOGRAVITY
		end
	end

	if mo.fuse2 > 0
		mo.fuse2 = $ - 1
		if mo.fuse2 == 0
			if hasplayer and not mo.fromsentry and not mo.deflected
				if mo.target.player.misdirection
					--mo.momx, mo.momy, mo.momz = $1/2, $2/2, $3/2
					ReadyMisdirect(mo)
				end
			end
		end
	end

	if mo.misdirecting ~= nil and hasplayer
		if mo.lifetime == charbalance.misdirectiondelay
			mo.dmomx = -mo.momx
			mo.dmomy = -mo.momy
			mo.dmomz = -mo.momz
		end
		if mo.misdirecting == 1 and mo.lifetime > charbalance.misdirectiondelay and not (mo.flags & MF_GRENADEBOUNCE) and not (mo.type == MT_THROWNBOUNCE)
			Misdirect(mo)
		end
	end

	if mo.lifetime ~= nil
		mo.lifetime = $ + 1
	end

	if mo.killtimer
		mo.killtimer = $ - 1
		if not mo.killtimer
			P_ExplodeMissile(mo)
			return
		end
	end

	-- No need for the commented out lines below as of 2.2 (Someone just shamelessly took my idea =)
	--if (mo.fuse2 == 0 and mo.target)
	--	if (mo.target.skin == "tails" and mo.target.fastshooting == 1)
	--		mo.momx, mo.momy, mo.momz = $1*3/2, $2*3/2, $3*3/2
	--	end
	--end
end

local function ShotDeflector(thing, tmthing)
	if (CanReflect(thing, tmthing) == false)
		return false
	end

	if (thing.z + thing.height < tmthing.z or thing.z > tmthing.z + tmthing.height)
		return false
	end

	if (tmthing.target == thing.target)
		return false
	end

	if (G_GametypeHasTeams())
		if (tmthing.target ~= nil and thing.target ~= nil)
			if (tmthing.target.player ~= nil and thing.target.player ~= nil)
				if Ally(tmthing.target.player,thing.target.player) -- If the projectile is my ally's
					return false -- Don't collide!
				end
			end
		end
	end

	if (tmthing.flags2 & MF2_RAILRING)
		local replacement = P_SpawnMobj(tmthing.x, tmthing.y, tmthing.z, MT_REDRING)
		replacement.deflected = 1
		if (not replacement.valid or replacement == nil)
			P_RemoveMobj(tmthing)
			return false
		end
		replacement.momx, replacement.momy, replacement.momz = tmthing.momx*4, tmthing.momy*4, tmthing.momz*4
		replacement.flags = tmthing.flags
		replacement.flags2 = tmthing.flags2
		replacement.flags2 = $ & ~MF2_RAILRING
		replacement.eflags = tmthing.eflags
		replacement.target = tmthing.target
		if (replacement.target.player)
			P_ColorTeamMissile(replacement, replacement.target.player)
		end
		P_RemoveMobj(tmthing)
	elseif (tmthing.fuse2)
		P_KillMobj(tmthing)
		return false
	else
		tmthing.deflected = 1
		tmthing.target = thing.target
		tmthing.tracer = nil
		tmthing.momx, tmthing.momy, tmthing.momz = -$1, -$2, -$3
	end

	if (tmthing and tmthing.valid and G_GametypeHasTeams() and tmthing.type == MT_REDRING)
		if (thing.target and thing.target.valid)
			if (thing.target.player)
				P_ColorTeamMissile(tmthing, thing.target.player)
			end
		end
	end

	S_StartSound(thing, sfx_s3k8b)

	return false
end

local function KnuxDeflectShots(thing, tmthing)
	if not (AppropriateGametype())
		return nil -- No perks in these gametypes!
	end

	if (KnuxReflectMissile(tmthing, thing, thing) == true)
		return false
	end

	return nil

end

local function KnuxBuddyDeflectShots(thing, tmthing)
	if not (AppropriateGametype())
		return false -- No perks in these gametypes!
	end

	if (KnuxReflectMissile(tmthing, thing, thing.target) == true)
		return false
	end

	return false

end

local function KnuxGetHit(target, inflictor, source)
	if gamestate ~= GS_LEVEL return end	

	if (target.buddy_table == nil) return end
	if (#target.buddy_table == 0) return end

	for i, mobj in ipairs(target.buddy_table)
		if not mobj continue end
		if not mobj.valid continue end
		P_RemoveMobj(mobj)
	end
end

local function KnuxResistBombs(target, inflictor, source, damage)
	if (inflictor == nil)
		return nil
	end
	if not (AppropriateGametype())
		return nil -- No perks in these gametypes!
	end
	if not (inflictor.flags2 & MF2_EXPLOSION) -- Only explosives, please!
		return nil
	end
	if (target.skin ~= "knuckles" or target.player == nil)
		return nil -- Not a valid Knux, sorry
	end
	if not (IsDeflecting(target))
		return nil -- Knux can survive explosions only in deflect mode
	end
	if source
		if (source.player)
			if Ally(target.player,source.player)
				return nil
			end
		end
	end
	S_StartSound(target, sfx_s3k7a)
	P_SuperDamage(target.player,inflictor,source)
	return false

end

local function KnuxConcentratingGetHit(target, inflictor, source, damage)
	if gamestate ~= GS_LEVEL return nil end

	if (target.damaging)
		return nil -- Stop recursion!
	end

	if not (AppropriateGametype())
		return nil -- No perks in these gametypes!
	end
	
	if (target.skin ~= "knuckles" or target.player == nil)
		return nil -- Not a valid Knux, sorry
	end

	if (target.player.powers[pw_super])
		return nil -- Don't overpower super even more!
	end

	if (target.player.concentrating == 0)
		return nil
	end

	if (source)
	if (source.valid and source.player)
		if (Ally(target.player, source.player))
				return nil
		end
	end
	end

	local tempshield = target.player.powers[pw_shield]
	target.player.powers[pw_shield] = SH_WHIRLWIND
	
	target.damaging = 1
	P_DamageMobj(target, inflictor, nil, 1)
	target.damaging = 0
	
	target.player.powers[pw_nocontrol] = TICRATE*2
	target.player.weapondelay = TICRATE*2
	target.player.powers[pw_shield] = tempshield
	target.player.weapondelay = 0
	KnuxStopConcentration(target)

	return false
end

local function KnuxBuddyGetHit(target, inflictor, source, damage)
	return false
end

local function FangCorkEatShots(thing, tmthing)
	if not (AppropriateGametype())
		return false
	end

	if (thing.z + thing.height < tmthing.z or thing.z > tmthing.z + tmthing.height)
		return false
	end

	if (thing.flags & MF_NOCLIPTHING) or (tmthing.flags & MF_NOCLIPTHING)
		return false
	end

	if (tmthing.target == thing.target)
		return false
	end

	if not (tmthing.flags & MF_MISSILE)
		return false
	end

	P_KillMobj(tmthing)

	return false
end

local function FangFrenzyGetHit(target, inflictor, source, damage)
	if not (AppropriateGametype())
		return -- No perks in these gametypes!
	end
	
	if (target.skin ~= "fang" or target.player == nil)
		return -- Not a valid Fang, sorry
	end

	if (target.player.onfrenzy == 0)
		return
	end

	target.player.onfrenzy = 0
	target.player.frenzytimer = 0
end

local function FangSpin(player)
	if not (AppropriateGametype())
		return -- No perks in these gametypes!
	end
	
	if player.mo == nil
		return
	end

	if (player.mo.skin ~= "fang")
		return -- Not a valid Fang, sorry
	end

	if not player.rweapondelay
		local newdelay = TICRATE/2
		if not player.onfrenzy
			//if player.speed > FixedMul(10<<FRACBITS, player.mo.scale)
			//	return true
			//end
			if not (player.cmd.buttons & BT_SPIN) and not (player.pflags & PF_SPINDOWN)
				return true
			end
			if not OnGround(player.mo)
				player.mo.momx, player.mo.momy = $1/2, $2/2
			end

			player.mo.state = S_PLAY_FIRE
			player.powers[pw_nocontrol] = newdelay
		else
			newdelay = TICRATE/3
		end
		if player.hearted > 0
			newdelay = $ * 2
		end
		player.rweapondelay = newdelay
		local shot = P_SPMAngle(player.mo, MT_CORK, player.mo.angle, 1, 0)
		if (shot)
			--shot.momx, shot.momy, shot.momz = $1*3/2, $2*3/2, $3*3/2
			shot.flags = $ | MF_SHOOTABLE
			shot.flags = $ & ~MF_NOBLOCKMAP
		end
	end
	return true
end

local function FangIsACheaterInTag(target, inflictor, source, damage)
	if not target or not inflictor or not source
		return nil
	end

	if not target.valid or not inflictor.valid or not source.valid
		return nil
	end

	if inflictor.type != MT_CORK
		return nil
	end

	if (target.z + target.height < inflictor.z or target.z > inflictor.z + inflictor.height)
		return nil
	end

	if target.type != MT_PLAYER or not target.player or not source.player
		return nil
	end

	if Ally(target.player,source.player)
		return nil
	end

	if not G_TagGametype()
		return nil
	end

	if target.player.fanged < 15*TICRATE
		P_SuperDamage(target.player, inflictor, nil)
		target.player.fanged = $ + 3*TICRATE
		target.player.rweapondelay = $ + TICRATE
	end
	return nil
end

local function HeartCollide(target, inflictor, source, damage)
	if not target or not inflictor or not source
		return nil
	end

	if not target.valid or not inflictor.valid or not source.valid
		return nil
	end

	if inflictor.type != MT_LHRT
		return nil
	end

	if (target.z + target.height < inflictor.z or target.z > inflictor.z + inflictor.height)
		return nil
	end

	if target.type == MT_PLAYER
		if not target.player or not source.player
			return nil
		end

		if inflictor.target == target
			return nil
		end

		if target.skin == "amy"
			return nil
		end

		local bt = 6*TICRATE
		if inflictor.nospawn ~= nil
			if inflictor.nospawn == 1
				bt = 2*TICRATE
			end
		end

		if Ally(target.player,source.player)
			S_StartSound(target,sfx_s227)
			target.player.powers[pw_flashing] = max($, bt)
			target.player.hearted = -1
		else
			S_StartSound(target,sfx_adderr)
			target.player.hearted = max($, bt*2)
		end
	end

	return nil
end

local function SentryThinker(mo)
	if not mo return end
	if not mo.valid return end

	if mo.fire == 1
		while true
			local checkv = 1
			if mo.shotmode == 2
				checkv = 2
			end

			if not mo.load[1][1]
				P_RemoveMobj(mo)
				return
			elseif (mo.load[1][1]-mo.lifetime < checkv)
				local flags2 = 0
				if (mo.load[2][1] == MT_REDRING)
					if #mo.load[5][1] == 1
						if mo.load[5][1][1] == MF2_RAILRING
							flags2 = $ | MF2_RAILRING
						end
					end
				end
				if mo.load[2][1] == MT_THROWNSCATTER
					targetoverride = mo.target
					mo.angle = mo.load[3][1]
					DoNiceScatter(mo, mo.load[4][1])
					targetoverride = 0
				else
					targetoverride = mo.target
					local shot = P_SMDblAngle(mo,mo.load[2][1],mo.load[3][1],mo.load[4][1],flags2)
					targetoverride = 0
					if shot
					if shot.valid
					for i = 1, NUM_WEAPONS
						if (shot.type != thingweapons[i]) continue end
						shot.flags2 = $ | flags2weapons[i]
						break
					end
					if (shot.type == MT_THROWNBOUNCE)
						shot.fuse = TICRATE*5
					elseif (shot.type == MT_THROWNGRENADE)
						shot.fuse = shot.info.reactiontime
					else
						if (shot.flags2 & MF2_RAILRING)
							S_StartSound(mo, sfx_rail1)
							DoRail(shot)
						end
					end
					end
					end
				end
				for i=1,#mo.load
					table.remove(mo.load[i],1)
				end
				continue
			end
			break
		end
		if mo.shotmode == 1
			if leveltime % 2 == 0
				mo.lifetime = $ + 1
			end
		elseif mo.shotmode == 2
			mo.lifetime = $ + 2
		else
			mo.lifetime = $ + 1
		end
	end
end

local function SentryScatter(target, inflictor, source, damage, damagetype)
	if not inflictor
		return nil
	end

	if not inflictor.valid
		return nil
	end

	if not (inflictor.flags2 & MF2_SCATTER) or not inflictor.fromsentry or not source or not target
		return nil
	end

	if not source.valid or not target.valid
		return nil
	end

	if not target.player
		return nil
	end

	if inflictor.dummy
		inflictor.dummy = 0
		return nil
	end
	inflictor.dummy = 1

	P_DamageMobj(target,inflictor,source,damage,damagetype)
	local ang = R_PointToAngle2(inflictor.x-inflictor.momx, inflictor.y-inflictor.momy, target.x-target.momx, target.y-target.momy)
	
	local dist = inflictor.lifetime*10
	dist = max(4,128-$)
	dist = FixedMul($*FRACUNIT, inflictor.scale)

	P_InstaThrust(target,ang,dist)
	return true
end

local function InitVars(mo)
	if (mo.player.flythokcooldown == nil)
		mo.player.flythokcooldown = 0
	end

	if (mo.player.usehold == nil)
		mo.player.usehold = 0
	end

	if (mo.player.weaponhold == nil)
		mo.player.weaponhold = {0,0,0,0,0,0,0}
	end

	if (mo.player.weaponholdrmn == nil)
		mo.player.weaponholdrmn = {0,0,0,0,0,0,0}
	end

	--if (mo.fastshooting == nil or mo.skin != "tails" or mo.player.powers[pw_super])
	--	mo.fastshooting = 1
	--end

	if (mo.theothermomx == nil or mo.theothermomy == nil or mo.theothermomz == nil)
		mo.theothermomx = 0
		mo.theothermomy = 0
		mo.theothermomz = 0
	end

	if (mo.theotherangle == nil)
		mo.theotherangle = 0
	end

	if (mo.player.concentrating == nil or mo.player.concentrationtimer == nil)
		mo.player.concentrating = 0
		mo.player.concentrationtimer = 0
	end

	if (mo.player.onfrenzy == nil or mo.player.frenzytimer == nil)
		mo.player.onfrenzy = 0
		mo.player.frenzytimer = 0
	end

	if (mo.buddy_table == nil)
		mo.buddy_table = {}
	end

	if (mo.sentry_table == nil)
		mo.sentry_table = {0,0,0,0,0,0}
	end

	if (mo.player.attacking == nil)
		mo.player.attacking = 0
	end

	if (mo.player.nattacking == nil)
		mo.player.nattacking = 0
	end

	if (mo.player.shotonce == nil)
		mo.player.shotonce = 0
	end

	if (mo.player.rweapondelay == nil)
		mo.player.rweapondelay = 0
	end

	if (mo.player.weapondelay2 == nil)
		mo.player.weapondelay2 = 0
	end

	if (mo.player.weapondelay3 == nil)
		mo.player.weapondelay3 = 0
	end

	if (mo.player.notshot == nil)
		mo.player.notshot = 0
	end

	if (mo.player.delayshot == nil)
		mo.player.delayshot = 0
	end

	if (mo.player.usedelayshot == nil)
		mo.player.usedelayshot = 0
	end

	if (mo.player.hearted == nil)
		mo.player.hearted = 0
	end

	if (mo.player.misdirection == nil)
		mo.player.misdirection = 0
	end

	if (mo.player.cometrush == nil)
		mo.player.cometrush = 0
	end

	if (mo.loadshots == nil)
		mo.loadshots = {{},{},{},{},{}}
	end

	if (mo.player.loadstart == nil)
		mo.player.loadstart = 0
	end

	if (mo.player.loadstartangle == nil)
		mo.player.loadstartangle = 0
	end

	if (mo.player.loadstartaiming == nil)
		mo.player.loadstartaiming = 0
	end

	if (mo.player.sentryload == nil)
		mo.player.sentryload = 0
	end

	if (mo.player.fanged == nil)
		mo.player.fanged = 0
	end

	if (mo.player.shotnum == nil)
		mo.player.shotnum = 0
		mo.player.owshotnum = 0
	end
end

local function PlayerMobjThinker(mo)
	if (mo.player == nil)
		return
	end
	if not (AppropriateGametype())
		return -- No perks in these gametypes!
	end

	InitVars(mo)

	if (mo.oldskin == nil)
		mo.oldskin = mo.skin
	end

	if (mo.player.oldweapon == nil)
		mo.player.oldweapon = mo.player.currentweapon
	end

	if (mo.player.cmd.buttons & BT_ATTACK)
		mo.player.attacking = $ + 1
	else
		mo.player.attacking = 0
	end

	if (mo.player.cmd.buttons & BT_FIRENORMAL)
		mo.player.nattacking = $ + 1
	else
		mo.player.nattacking = 0
	end

	if (mo.skin)
		if (mo.skin != mo.oldskin)
			mo.oldskin = mo.skin
			CBReset(mo.player)
		end
	end

	if (mo.player.oldweapon != mo.player.currentweapon)
		mo.player.owshotnum = 0
		mo.player.oldweapon = mo.player.currentweapon
	end

	if mo.skin == "knuckles"
		if (mo.player.glidetime == 0)
			mo.theothermomx = 0
			mo.theothermomy = 0
			mo.theothermomz = 0
		end
		mo.theothermomx = $1*8/9
		mo.theothermomy = $1*8/9
		mo.theothermomz = $1*8/9

		P_TryMove(mo, mo.x+mo.theothermomx, mo.y+mo.theothermomy, true)
		mo.z = $1 + mo.theothermomz
	end

	if (mo.player.concentrating)
		if (mo.player.concentrationtimer < charbalance.concentrationmax and not (mo.player.pflags & PF_GLIDING))
			mo.player.concentrationtimer = $1 + 1
		elseif (mo.player.concentrationtimer >= charbalance.concentrationmax)
			KnuxStopConcentration(mo)
		end
	else
		if (mo.player.concentrationtimer > -charbalance.concentrationtimeout-TICRATE and not (#mo.buddy_table))
			mo.player.concentrationtimer = $1 - 1
		end
	end

	if (mo.player.cmd.buttons & BT_USE)
		mo.player.usehold = $ + 1
	else
		if mo.skin == "metalsonic"
			if (mo.player.secondjump == 1 or mo.state == S_PLAY_SPRING or mo.state == S_PLAY_FALL) and not mo.player.gotflag
				if mo.player.usehold > 0 and mo.player.usehold < TICRATE
					mo.player.misdirection = !$
					S_StartSound(mo, sfx_s3k7c)
				elseif mo.player.usehold >= TICRATE and mo.player.cometrush < -charbalance.cometrushtimeout
					mo.theotherangle = mo.angle
					//mo.theothermomx, mo.theothermomy = cos(mo.angle) * charbalance.cometrushspeed, sin(mo.angle) * charbalance.cometrushspeed
					mo.player.cometrush = 5*TICRATE
					S_StartSound(mo, sfx_kc4d)
				end
			end
		end
		mo.player.usehold = 0
	end
	for i=1,#mo.player.weaponhold
		if ((mo.player.cmd.buttons & BT_WEAPONMASK) == i)
			mo.player.weaponhold[i] = $ + 1
		else
			if mo.player.weaponhold[i] > 0
				if mo.player.weaponholdrmn[i] > 0
					mo.player.weaponholdrmn[i] = 0
				else
					mo.player.weaponholdrmn[i] = TICRATE/2
				end
			end
			mo.player.weaponhold[i] = 0
			if mo.player.weaponholdrmn[i] > 0
				mo.player.weaponholdrmn[i] = $ - 1
			end
		end
	end
	if mo.player.weapondelay2
		mo.player.weapondelay2 = $ - 1
	end
	if mo.player.weapondelay3
		mo.player.weapondelay3 = $ - 1
	end

	if (mo.player.onfrenzy)
		if (mo.player.frenzytimer < charbalance.frenzytime)
			mo.player.frenzytimer = $ + 1
		else
			mo.player.frenzytimer = 0
			mo.player.onfrenzy = 0
		end
	else
		if (mo.player.frenzytimer > -charbalance.frenzytimeout-TICRATE)
			mo.player.frenzytimer = $1 - 1
		end
	end

	if mo.skin ~= "tails"
		mo.player.usedelayshot = 0
	end

	if ((mo.player.attacking or mo.player.nattacking) and Ready2Fire(mo.player))
		DoFire(mo.player)
	end

	if mo.skin == "tails"
		if (mo.player.powers[pw_super])
			return -- Don't overpower super even more!
		end

		if (mo.player.weaponhold[1] == 2*TICRATE)
			S_StartSound(mo, sfx_s3k7c)
		elseif (mo.player.weaponhold[1] > 2*TICRATE)
			mo.player.delayshot = mo.player.weaponhold[1] - 2*TICRATE
		end

		if (mo.player.weaponhold[2] == 1 and mo.player.weaponholdrmn[2] > 0)
			S_StartSound(mo, sfx_s3k7c)
			mo.player.usedelayshot = !$
		end
		

		if (mo.player.flythokcooldown == 0 and mo.player.powers[pw_tailsfly]
		and (mo.player.cmd.buttons & BT_USE) and (mo.player.cmd.buttons & BT_JUMP))
			-- Do Fly-Burst
			mo.player.flythokcooldown = TICRATE/2
			local force = FRACUNIT*20
			mo.momx = FixedMul(FixedMul(FixedMul(force, cos(mo.angle)), cos(mo.player.aiming)), mo.scale)
			mo.momy = FixedMul(FixedMul(FixedMul(force, sin(mo.angle)), cos(mo.player.aiming)), mo.scale)
			mo.momz = FixedMul(FixedMul(force, sin(mo.player.aiming)), mo.scale)
			local first = 0
			local second = 0
			if (mo.eflags & MFE_VERTICALFLIP)
				if (mo.momz < -FRACUNIT*10)
					mo.momz = -FRACUNIT*10
				elseif (mo.momz > FRACUNIT*22)
					mo.momz = FRACUNIT*22
				end
			else
				if (mo.momz > FRACUNIT*10)
					mo.momz = FRACUNIT*10
				elseif (mo.momz < -FRACUNIT*22)
					mo.momz = -FRACUNIT*22
				end
			end
			if (maptol & TOL_2D)
				mo.momx = $ / 3 * 2
				mo.momy = $ / 3 * 2
				mo.momz = $ / 3 * 2
			end
			if (mo.player.powers[pw_tailsfly] < TICRATE)
				mo.player.powers[pw_tailsfly] = 0
			else
				mo.player.powers[pw_tailsfly] = $ - TICRATE
			end
			if ((mo.eflags & MFE_UNDERWATER) or (mo.eflags & MFE_GOOWATER))
				mo.momx = $ / 3 * 2
				mo.momy = $ / 3 * 2
				mo.momz = $ / 3 * 2
			else
				local mygust = P_SpawnMobj(mo.x, mo.y, mo.z, MT_TWINDGUST)
				mygust.target = mo
			end
			S_StartSound(mo, sfx_s3k47)
		end

		if (mo.player.flythokcooldown > 0)
			mo.player.flythokcooldown = $ - 1
		end
	elseif mo.skin == "knuckles"
		if (mo.player.powers[pw_super])
			return -- Don't overpower super even more!
		end
		DoKnuxSFX(mo)
		--mo.player.acceleration = skins[mo.skin].acceleration * 5 / 4
		--mo.player.accelstart = skins[mo.skin].accelstart * 5 / 4

		for i, mobj in ipairs(mo.buddy_table)
			if not (mobj.valid) table.remove(mo.buddy_table,i) break end
			if not (mobj.fuse) table.remove(mo.buddy_table,i) P_RemoveMobj(mobj) break end
			mobj.skin = mo.skin
			mobj.angle = mo.angle
			mobj.color = mo.color
			local newtrans = FF_TRANS50
			if (mobj.fuse < 2*TICRATE)
				newtrans = FF_TRANS80
			elseif (mobj.fuse < 5*TICRATE)
				newtrans = FF_TRANS70
			elseif (mobj.fuse < 10*TICRATE)
				newtrans = FF_TRANS60
			end
			--mobj.sprite = mo.sprite
			mobj.state = mo.state
			mobj.frame = newtrans | mo.frame
			P_TeleportMove(mobj, mo.x+FixedMul(FixedMul(mo.radius*4,cos(mo.angle+ANGLE_90)),cos((i-1)*ANGLE_45)), mo.y+FixedMul(FixedMul(mo.radius*4,sin(mo.angle+ANGLE_90)),cos((i-1)*ANGLE_45)), mo.z+FixedMul(mo.radius*4,sin((i-1)*ANGLE_45)))
		end

		if (mo.player.concentrating)
			if (mo.player.pflags & PF_GLIDING and mo.player.concentrationtimer)
				if (#mo.buddy_table == 0)
					for i = 1,charbalance.numbuddies
						local newbuddy = P_SpawnMobj(mo.x, mo.y, mo.z, MT_EXTRAKNUXEDBUDDY)
						newbuddy.target = mo
						newbuddy.fuse = 15*TICRATE
						newbuddy.count = i
						table.insert(mo.buddy_table, newbuddy)
					end
				end
				KnuxStopConcentration(mo)
			elseif ((mo.player.cmd.buttons & BT_ATTACK) or (mo.player.cmd.buttons & BT_FIRENORMAL))
--				Empty Spaaaaaaace =}
			elseif (mo.player.powers[pw_super])
				KnuxStopConcentration(mo)
			end
			if (mo.player.concentrationtimer % TICRATE/2 == 0)
				P_SpawnMobj(mo.x, mo.y, mo.z, MT_SPARK)
			end
		elseif (mo.player.concentrationtimer < -charbalance.concentrationtimeout and mo.player.glidetime and (mo.player.cmd.buttons & BT_USE))
			mo.player.concentrating = 1
			mo.player.concentrationtimer = 0
			S_StartSound(thing, sfx_s3k49)
			mo.player.pflags = $ | PF_SPINNING
			mo.player.pflags = $ & ~PF_JUMPED
			mo.player.pflags = $ & ~PF_GLIDING
		end
	elseif mo.skin == "fang"
		if (mo.player.weapondelay == 0)
			mo.player.notshot = 0
		end

		if not mo.player.onfrenzy and (mo.player.frenzytimer < -charbalance.frenzytimeout and (mo.player.pflags & PF_BOUNCING) and (mo.player.cmd.buttons & BT_USE))
			mo.player.onfrenzy = 1
			mo.player.frenzytimer = 0
			S_StartSound(thing, sfx_s3k49)
			mo.player.pflags = $ | PF_SPINNING
			mo.player.pflags = $ & ~PF_JUMPED
			mo.player.pflags = $ & ~PF_BOUNCING
		end

	elseif mo.skin == "metalsonic"
		if mo.player.cometrush > 0
			mo.momx, mo.momy, mo.momz = 0,0,0
			mo.theotherangle = $ + (mo.angle - $) / TICRATE
			mo.theothermomx = cos(mo.theotherangle) * charbalance.cometrushspeed
			mo.theothermomy = sin(mo.theotherangle) * charbalance.cometrushspeed
			mo.dashmode = 3*TICRATE
			mo.player.powers[pw_invulnerability] = 2
			mo.player.powers[pw_flashing] = 2
			if (mo.state == S_PLAY_PAIN or mo.state == S_PLAY_DEAD)
				mo.player.cometrush = 0
			elseif mo.state != S_PLAY_DASH
				mo.state = S_PLAY_DASH
			end
			if not P_TryMove(mo, mo.x+mo.theothermomx, mo.y+mo.theothermomy, true) or mo.player.usehold == 2
				mo.momx = mo.theothermomx
				mo.momy = mo.theothermomy
				mo.player.cometrush = 0
				if not (P_IsObjectOnGround(mo))
					mo.player.secondjump = 1
				end
				mo.player.usehold = -TICRATE
				mo.player.powers[pw_flashing] = flashingtics-1
			end
		end
		if mo.player.cometrush > -100*TICRATE
			mo.player.cometrush = $ - 1
			if mo.player.cometrush == 0
				mo.momx = mo.theothermomx
				mo.momy = mo.theothermomy
				mo.player.secondjump = 1
				mo.player.usehold = -TICRATE
				mo.player.powers[pw_flashing] = flashingtics-1
			end
		end
		for i=1,#mo.sentry_table
			if (mo.sentry_table[i] != 0)
				if not (mo.sentry_table[i].valid)
					mo.sentry_table[i] = 0
				end
			end

			if (mo.player.weaponhold[i] == TICRATE/2 and mo.player.weaponholdrmn[i] == 0 and mo.sentry_table[i] != 0)
				mo.sentry_table[i].shotmode = ($ + 1) % 3
				 S_StartSound(mo,sfx_jshard)
			end

			if mo.player.weaponhold[i] == TICRATE/2 and mo.player.loadstart == 0 and mo.player.sentryload > 0
				SaveWeapons(mo.player)
				if not CheckLoadAmmo(mo.player)
					LoadWeapons(mo.player)
					mo.player.sentryload = 0
					continue
				end
				S_StartSound(mo,sfx_jshard)
				mo.player.loadstart = 1
			elseif (mo.player.weaponholdrmn[i] <= 0 or mo.player.weaponhold[i] != 1) continue end
			
			if mo.player.loadstart == 0 and mo.player.sentryload > 0
				mo.loadshots = {{},{},{},{},{}}
			end
			if (mo.sentry_table[i] != 0)
				if (mo.sentry_table[i].fire) continue end
				mo.sentry_table[i].fire = 1
				break
			end
			if mo.player.sentryload == 0
				mo.player.sentryload = i
				break
			elseif mo.player.sentryload == i
				if #mo.loadshots[1]
					S_StartSound(mo,sfx_kc44)
					mo.sentry_table[i] = P_SpawnMobj(mo.x,mo.y,mo.z,MT_SENTRY)
					mo.sentry_table[i].target = mo
					mo.sentry_table[i].color = mo.color
					mo.sentry_table[i].fire = 0
					mo.sentry_table[i].lifetime = 0
					mo.sentry_table[i].load = {{},{},{},{},{}}
					mo.sentry_table[i].shotmode = 0
					local num = #mo.sentry_table[i].load
					for j=1,#mo.loadshots[1]
						for k=1,num-1
							local output = mo.loadshots[k][j]
							if k == 3
								output = $ + mo.angle - mo.player.loadstartangle
							elseif k == 4
								output = $ + mo.player.aiming - mo.player.loadstartaiming
							end
							table.insert(mo.sentry_table[i].load[k],output)
						end
						mo.sentry_table[i].load[num][j] = {}
						for k=1,#mo.loadshots[num][j]
							table.insert(mo.sentry_table[i].load[num][j],mo.loadshots[num][j][k])
						end
					end
				else
					mo.loadshots = {{},{},{},{},{}}
				end
				mo.player.sentryload = 0
				mo.player.loadstart = 0
				//mo.player.loadstartangle = 0
				//mo.player.loadstartaiming = 0
				
			end
			break
		end
		if (mo.player.weaponhold[7] == 1 and mo.player.weaponholdrmn[7] > 0)
			for i=1,#mo.sentry_table
				if (mo.sentry_table[i] == 0)
					continue
				end
				mo.sentry_table[i].fire = 1
			end
		end
	end

	if mo.player.hearted > 0
		mo.player.normalspeed = skins[mo.skin].normalspeed / 2
		mo.player.acceleration = skins[mo.skin].acceleration / 2
		mo.player.accelstart = skins[mo.skin].accelstart / 2
		mo.player.actionspd = skins[mo.skin].actionspd / 2
		mo.player.hearted = $ - 1
		if (mo.player.hearted == 0)
			mo.player.normalspeed = skins[mo.skin].normalspeed
			mo.player.acceleration = skins[mo.skin].acceleration
			mo.player.accelstart = skins[mo.skin].accelstart
			mo.player.actionspd = skins[mo.skin].actionspd
		end
	end
	if mo.player.fanged
		mo.player.fanged = $ - 1
	end
	if mo.player.rweapondelay
		mo.player.rweapondelay = $ - 1
	end
	mo.player.weapondelay = max(1,mo.player.rweapondelay)

	if mo.player.shotonce and not mo.player.attacking and not mo.player.nattacking
		mo.player.shotonce = 0
	end

	if mo.player.hearted == -1
	if mo.player.powers[pw_flashing] >= flashingtics - 1
		if (leveltime & 1)
			mo.flags2 = $ | MF2_DONTDRAW
		else
			mo.flags2 = $ & ~MF2_DONTDRAW
		end
		mo.player.powers[pw_flashing] = $ - 1
	elseif mo.player.powers[pw_flashing] == 0
		mo.player.hearted = 0
	end
	end
end

local function ConcentrationHurtMsg(player, inflictor, source)
	if gamestate ~= GS_LEVEL return end
	if (player.mo == nil) return false end

	if (player.mo.skin ~= "knuckles")
		return false -- Not a valid Knux, sorry
	end

	if (player.powers[pw_super])
		return false -- Supers can't concentrate!
	end

	if (player.concentrating == 0) return false end
	return true
end

-- ~
-- Hooks for gameplay
-- ~

addHook("MobjThinker", ShotThink, MT_NULL)
addHook("MobjCollide", ShotDeflector, MT_TWINDGUST)
addHook("MobjCollide", KnuxDeflectShots, MT_PLAYER)
addHook("MobjCollide", KnuxBuddyDeflectShots, MT_EXTRAKNUXEDBUDDY)
addHook("MobjDamage", KnuxGetHit, MT_PLAYER)
addHook("MobjDeath", KnuxGetHit, MT_PLAYER)
addHook("ShouldDamage", KnuxResistBombs, MT_PLAYER)
addHook("ShouldDamage", KnuxConcentratingGetHit, MT_PLAYER)
addHook("ShouldDamage", KnuxBuddyGetHit, MT_EXTRAKNUXEDBUDDY)
addHook("MobjCollide", FangCorkEatShots, MT_CORK)
addHook("MobjDamage", FangFrenzyGetHit, MT_PLAYER)
addHook("SpinSpecial", FangSpin, MT_PLAYER)
addHook("ShouldDamage", FangIsACheaterInTag, MT_PLAYER)
addHook("MobjThinker", SentryThinker, MT_SENTRY)
//addHook("MobjDeath", SentryDie, MT_SENTRY)
addHook("MobjDamage", SentryScatter, MT_PLAYER)
addHook("MobjThinker", PlayerMobjThinker, MT_PLAYER)
addHook("HurtMsg", ConcentrationHurtMsg)
addHook("PlayerThink", function(player)
	if not player.mo
		return
	end

	if AppropriateGametype()
		if player.mo.skin == "fang" and player.charability2 & CA2_GUNSLINGER
			player.charability2 = $ & ~CA2_GUNSLINGER
		end
	end
end)
addHook("ShouldDamage", HeartCollide, MT_PLAYER)

hud.add(function(v, p)
	if (splitscreen) return end -- Can't make it work in Splitscreen
	if (p.spectator) return end
	if not (charbalance.cv_charbalancehud.value) return end
	if not (AppropriateGametype())
		return
	end
	if (p.mo == nil) return end
	if (p.powers[pw_super]) return end
	if (p.mo.oldskin == nil) return end
	if (p.mo.skin == "tails")
		local dsstring = "Delay Shot : " + G_TicsToSeconds(p.delayshot) + "." + G_TicsToMilliseconds(p.delayshot)/100 + "s"
		if (p.usedelayshot)
			dsstring = $ + " \131(+)"
		end
		v.drawString(160, 160, dsstring, V_30TRANS, "center")
	elseif (p.mo.skin == "knuckles")
		local ctimeout = p.concentrationtimer + charbalance.concentrationtimeout
		if (#p.mo.buddy_table)
			v.drawString(160, 160, "Concentration : \131Multi-Knux!", V_30TRANS, "center")
		elseif (p.concentrating)
			local cleft = charbalance.concentrationmax - p.concentrationtimer
			v.drawString(160, 160, "Concentration : \131Active!" + "(" + (cleft+TICRATE)/TICRATE + "s left)", V_30TRANS, "center")
		elseif (ctimeout > 0)
			v.drawString(160, 160, "Concentration : \133Ready in " + (ctimeout+TICRATE)/TICRATE + "s", V_30TRANS, "center")
		elseif (p.pflags & PF_GLIDING)
			v.drawString(160, 160, "Concentration : \131Spin to activate!", V_30TRANS, "center")
		else
			v.drawString(160, 160, "Concentration : \131Ready!", V_30TRANS, "center")
		end
		if (IsDeflecting(p.mo))
			v.drawString(160, 168, "Deflect shots : \131Active!", V_30TRANS, "center")
		else
			v.drawString(160, 168, "Deflect shots : \133Not active", V_30TRANS, "center")
		end
	elseif (p.mo.skin == "fang")
		local ftimeout = p.frenzytimer + charbalance.frenzytimeout
		if (p.onfrenzy)
			local fleft = charbalance.frenzytime - p.frenzytimer
			v.drawString(160, 160, "Frenzy : \131Active!" + "(" + (fleft+TICRATE)/TICRATE + "s left)", V_30TRANS, "center")
		elseif (ftimeout > 0)
			v.drawString(160, 160, "Frenzy : \133Ready in " + (ftimeout+TICRATE)/TICRATE + "s", V_30TRANS, "center")
		elseif (p.pflags & PF_BOUNCING)
			v.drawString(160, 160, "Frenzy : \131Spin to activate!", V_30TRANS, "center")
		else
			v.drawString(160, 160, "Frenzy : \131Ready!", V_30TRANS, "center")
		end
	elseif (p.mo.skin == "metalsonic")
		local md = 0
		local cr = 0
		if (p.secondjump == 1 or p.mo.state == S_PLAY_SPRING or p.mo.state == S_PLAY_FALL) and not p.gotflag
			if p.usehold > 0 and p.usehold < TICRATE
				md = -1
			elseif p.usehold >= TICRATE and p.cometrush < -charbalance.cometrushtimeout
				cr = -1
			end
		end

		if (p.misdirection)
			v.drawString(160, 160, "Misdirection : \131Active!", V_30TRANS, "center")
		else
			if (md == -1)
				v.drawString(160, 160, "Misdirection : \131Release spin to activate!", V_30TRANS, "center")
			else
				v.drawString(160, 160, "Misdirection : \133Not active", V_30TRANS, "center")
			end
		end
		if p.cometrush > 0
			v.drawString(160, 152, "Comet Rush : \131Active!", V_30TRANS, "center")
		else
			local crleft = charbalance.cometrushtimeout + p.cometrush
			if crleft > 0
				v.drawString(160, 152, "Comet Rush : \133Ready in " + (crleft+TICRATE)/TICRATE + "s", V_30TRANS, "center")
			elseif (cr == -1)
				v.drawString(160, 152, "Comet Rush : \131Release spin to activate!", V_30TRANS, "center")
			else
				v.drawString(160, 152, "Comet Rush : \133Not active", V_30TRANS, "center")
			end
		end
		local sentrypre = {"\128","\128","\128","\128","\128","\128"}
		for i=1,#p.mo.sentry_table
			if (p.sentryload == i)
				sentrypre[i] = "\135"
				continue
			end
			if (p.mo.sentry_table[i] == 0) continue end
			if not (p.mo.sentry_table[i].valid) continue end
			if (p.mo.sentry_table[i].fire)
				sentrypre[i] = "\133"
				continue
			end
			sentrypre[i] = "\131"
		end
		local sentrystr = "Sentry:"

		for i=1,6
			sentrystr = $+sentrypre[i]+" "+i
			if p.mo.sentry_table[i] == 0 continue end
			if not p.mo.sentry_table[i].valid continue end
			if p.mo.sentry_table[i].shotmode == 1
				v.drawString(147+i*12, 176, "S", V_30TRANS, "center")
			elseif p.mo.sentry_table[i].shotmode == 2
				v.drawString(147+i*12, 176, "F", V_30TRANS, "center")
			end
		end
		v.drawString(160, 168, sentrystr, V_30TRANS, "center")
	end
end, "game")
