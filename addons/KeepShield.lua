addHook("PlayerThink", function(p)
if not (p and p.mo and p.mo.valid and p.exiting and (gametyperules & GTR_FRIENDLY)) return end
	p.keepshield = p.powers[pw_shield]
end)

addHook("PlayerSpawn", function(p)
if p.keepshield == nil or not (gametyperules & GTR_FRIENDLY) return end
if p.mo.skin == "mario" or p.mo.skin == "skip" return end
if (gamemap == 104 or gamemap == 107 or gamemap == 110 or gamemap == 113 or gamemap == 116 or gamemap == 119 or gamemap == 132 or gamemap == 135) return end
if (gamemap == 4 or gamemap == 7 or gamemap == 10 or gamemap == 13 or gamemap == 16 or gamemap == 22 or gamemap == 25) return end
if mapheaderinfo[gamemap].actnum == 1 return end
	p.powers[pw_shield] = p.keepshield
	P_SpawnShieldOrb(p)
	p.keepshield = nil
end)