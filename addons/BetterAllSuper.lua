//Made by Lunar, original idea from AllSuper.wad
//This makes it so that any character can turn super in singleplayer and co-op.

addHook("ThinkFrame", do
    for player in players.iterate
        if not (player.charflags & SF_SUPER)
            player.charflags = $1 + SF_SUPER
		end
	end
end)

