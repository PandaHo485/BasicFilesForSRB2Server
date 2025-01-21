/*
Skin Banning
	by Lach
*/

local bannedskins = {}
local numbanned = 0

addHook("NetVars", function(net)
	bannedskins = net(bannedskins)
	numbanned = net(numbanned)
end)

COM_AddCommand("banskin", function(player, arg)
	if not arg
		CONS_Printf(player, "Bans a character skin, or unbans it if already banned.")
		return
	end
	local num = tonumber(arg)
	if num ~= nil
		if num >= 0 and num < 32 and skins[num]
			arg = skins[num].name
		elseif num == -1
			bannedskins = {}
			numbanned = 0
			CONS_Printf(player, "All skins have been unbanned.")
			return
		end
	else
		arg = $:lower()
	end
	if skins[arg]
		local n = #skins[arg] + 1
		if bannedskins[n]
			bannedskins[n] = nil
			numbanned = $ - 1
			CONS_Printf(player, "Lifted ban on skin \""..arg.."\".")
			return
		end
		if #skins - 1 <= numbanned
			CONS_Printf(player,"You can't ban the only remaining skin!")
			return
		end
		bannedskins[n] = true
		numbanned = $ + 1
		CONS_Printf(player, "Skin \""..arg.."\" has been banned.")
		return
	end
	CONS_Printf(player, "You can't ban a nonexistent skin!")
end,1)

COM_AddCommand("listbannedskins", function(player)
	if table.maxn(bannedskins) <= 0
		CONS_Printf(player, "There are no currently banned skins!")
		return
	end
	CONS_Printf(player, "List of banned skins:")
	for i = 1, table.maxn(bannedskins)
		if bannedskins[i]
			CONS_Printf(player, "\t\""..skins[i-1].name.."\"")
		end
	end
end)

addHook("ThinkFrame", do
	if table.maxn(bannedskins) <= 0 return end
	for player in players.iterate
		if player.mo
			if not player.diceroll_counter and bannedskins[#skins[player.mo.skin] + 1]
				if player.diceroll_skin ~= nil
					if bannedskins[player.diceroll_skin + 1]
						local i = P_RandomKey(#skins) + 1
						while bannedskins[i]
							i = P_RandomKey(#skins) + 1
						end
						player.diceroll_skin = i - 1
					end
				else
					CONS_Printf(player, "You currently cannot play with the skin \""..player.mo.skin.."\" as it has been banned.")
					if player.safeskin and not bannedskins[#skins[player.safeskin] + 1]
						R_SetPlayerSkin(player, player.safeskin)
					else
						local i = 1
						while bannedskins[i]
							i = $ + 1
						end
						R_SetPlayerSkin(player, i - 1)
					end
				end
			end
			player.safeskin = player.mo.skin
		end
	end
end)
