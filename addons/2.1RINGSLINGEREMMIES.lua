local function superemeraldcheck(player)
	if G_RingSlingerGametype()
		if not All7Emeralds(emeralds)
			P_SpawnMobj(player.mo.x,player.mo.y,player.mo.z, MT_EMERALD1)
			P_SpawnMobj(player.mo.x,player.mo.y,player.mo.z, MT_EMERALD2)
			P_SpawnMobj(player.mo.x,player.mo.y,player.mo.z, MT_EMERALD3)
			P_SpawnMobj(player.mo.x,player.mo.y,player.mo.z, MT_EMERALD4)
			P_SpawnMobj(player.mo.x,player.mo.y,player.mo.z, MT_EMERALD5)
			P_SpawnMobj(player.mo.x,player.mo.y,player.mo.z, MT_EMERALD6)
			P_SpawnMobj(player.mo.x,player.mo.y,player.mo.z, MT_EMERALD7)
		end
	end
end

addHook("PlayerThink", superemeraldcheck)

addHook("ThinkFrame", do
	for player in players.iterate
        if player.mo == nil then continue end
		if (player.powers[pw_invulnerability] == 20*TICRATE)
		and (player.powers[pw_sneakers] == 20*TICRATE)
		and G_RingSlingerGametype()
			player.powers[pw_emeralds] = 127
			player.powers[pw_sneakers] = 0
			player.powers[pw_invulnerability] = 1
			player.charflags = $1 + SF_SUPER
		end
		if player.powers[pw_emeralds] <= 126 and G_RingSlingerGametype()
			player.charflags = $1 & ~SF_SUPER
		end
	end
end)

/*
addHook("ThinkFrame", do
    for player in players.iterate
        if player.mo == nil then continue end
		-- Fixes for super system that SRB2 2.2 disabled it in ringslinger:
		-- 1- Player must jump correctly with the jumps flags
		if player.powers[pw_super]
		and P_IsObjectOnGround(player.mo)
		and player.cmd.buttons & BT_JUMP
			player.pflags = $1 + PF_JUMPED
			player.mo.state = S_PLAY_JUMP
		end
    end
end)
*/

local matchemeralds = {
	MT_EMERALD1,
	MT_EMERALD2,
	MT_EMERALD3,
	MT_EMERALD4,
	MT_EMERALD5,
	MT_EMERALD6,
	MT_EMERALD7,
	MT_FLINGEMERALD
}

addHook("TouchSpecial", function(special, toucher)
	if (toucher.player and toucher.player.powers[pw_emeralds] == 127)
		return true
	end
end, MT_EMERALD1)

addHook("TouchSpecial", function(special, toucher)
	if (toucher.player and toucher.player.powers[pw_emeralds] == 127)
		return true
	end
end, MT_EMERALD2)

addHook("TouchSpecial", function(special, toucher)
	if (toucher.player and toucher.player.powers[pw_emeralds] == 127)
		return true
	end
end, MT_EMERALD3)

addHook("TouchSpecial", function(special, toucher)
	if (toucher.player and toucher.player.powers[pw_emeralds] == 127)
		return true
	end
end, MT_EMERALD4)

addHook("TouchSpecial", function(special, toucher)
	if (toucher.player and toucher.player.powers[pw_emeralds] == 127)
		return true
	end
end, MT_EMERALD5)

addHook("TouchSpecial", function(special, toucher)
	if (toucher.player and toucher.player.powers[pw_emeralds] == 127)
		return true
	end
end, MT_EMERALD6)

addHook("TouchSpecial", function(special, toucher)
	if (toucher.player and toucher.player.powers[pw_emeralds] == 127)
		return true
	end
end, MT_EMERALD7)

addHook("TouchSpecial", function(special, toucher)
	if (toucher.player and toucher.player.powers[pw_emeralds] == 127)
		return true
	end
end, MT_FLINGEMERALD)

addHook("ShouldDamage", function(target, inflictor, source, damage)
	if target.player.powers[pw_super]
		if (inflictor and inflictor.type == MT_SPINFIRE) or (source and source.type == MT_SPINFIRE)
		or (inflictor and inflictor.flags & MF_MISSILE) or (source and source.flags & MF_MISSILE)
			target.player.rings = $1 - 10
			S_StartSound(target.player.mo, sfx_altow1)
			print(target.player.name.." was hit with the 10 rings being decreased!")
		end
	end
end, MT_PLAYER)
