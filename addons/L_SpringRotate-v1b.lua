-- Spring Rotate has been created by me, ThatOneCartridgeGuy!
-- Based on Custom Player Death by TGTLS (check his mods out)

addHook("PlayerSpawn", function(player)
if player.sprung == nil
player.sprung = false
end
end)

addHook("PlayerThink", function(player)
if player and player.mo and player.valid and player.mo.valid 
and player.mo.eflags & MFE_SPRUNG or player.powers[pw_justsprung] 
and not P_IsObjectOnGround(player.mo) and not player.bot then
player.sprung = true
player.mo.state = S_PLAY_WALK
end
if player.mo and player.valid and player.mo.valid and not P_IsObjectOnGround(player.mo)
and player.mo.state == S_PLAY_WALK and player.sprung == true and player.mo.momz <= 0 then
player.mo.rollangle = 0 
player.sprung = false
player.rerollangle = 0
end
end)

addHook("PlayerThink", function(p)
	if p.rerollangle == nil
		p.rerollangle = 0
	end
	if p.mo and p.mo.valid and p.sprung
	and p.mo.state == S_PLAY_WALK
	and p.playerstate == PST_LIVE
    and not P_IsObjectOnGround(p.mo)
		p.mo.rollangle = p.rerollangle
		p.rerollangle = $+ANG10
	end
end)

addHook("FollowMobj", function(player, tails)
if not player.mo and player.mo.skin == "tails" return end
if not tails and tails.type == MT_TAILSOVERLAY return end

if player.sprung == true and player.mo.state == S_PLAY_WALK
and not player.powers[pw_tailsfly] and player.charability == CA_FLY
and not P_IsObjectOnGround(player.mo) and not player.bot then
tails.rollangle = player.mo.rollangle
else
tails.rollangle = 0
end
end, MT_TAILSOVERLAY)
