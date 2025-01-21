//man553 color plus
//some colors made by chicmunk go check out his stuff lol

local cv_transparencyallow = CV_RegisterVar({"allowtransparent", "On", CV_NETVAR, CV_OnOff})

local i = "SKINCOLOR_"
freeslot(i+"BRAK",i+"SUNDOWN",i+"SUNNY",i+"SLADE",i+"NOVA",i+"TURQUOISE",i+"NOCTURNALBLUE",i+"GAMEBOY",i+"VIRUS",i+"HEX",i+"TROJAN",i+"VOID",i+"GLITZ",i+"HOTPINK",i+"EXPIREDMILK",i+"PLAINY",i+"WINDY",i+"HMS",i+"STEELBOLT",i+"BLACKBERRY",i+"OIL",i+"MOUTHWASH",i+"BERYL",i+"APPLEJACK",i+"BREEZY",i+"PRISTY",i+"COLD",i+"TRANSPARENT",i+"FLICKERLIGHT",i+"FLUORERED",i+"GLAZEBLUE",i+"LIGHTINGGREEN")

skincolors[SKINCOLOR_BRAK] = {
    name = "Brak",
    ramp = {36,36,37,38,43,71,71,71,239,28,29,29,29,30,31,31},
    invcolor = SKINCOLOR_GAMEBOY,
    invshade = 7,
    chatcolor = V_BLACKMAP,
    accessible = true
}

skincolors[SKINCOLOR_SUNDOWN] = {
    name = "Sundown",
    ramp = {32,33,34,34,204,204,204,205,205,197,197,174,174,175,175,253},
    invcolor = SKINCOLOR_EMERALD,
    invshade = 7,
    chatcolor = V_ORANGEMAP,
    accessible = true
}

skincolors[SKINCOLOR_SUNNY] = {
    name = "Sunny",
    ramp = {72,73,73,74,74,74,65,66,66,67,67,68,70,78,71,72},
    invcolor = SKINCOLOR_NOCTURNALBLUE,
    invshade = 7,
    chatcolor = V_YELLOWMAP,
    accessible = true
}

skincolors[SKINCOLOR_SLADE] = {
    name = "Slade",
    ramp = {0,128,140,141,141,136,137,137,138,159,159,253,253,254,254,31},
    invcolor = SKINCOLOR_NOVA,
    invshade = 7,
    chatcolor = V_BLUEMAP,
    accessible = true
}

skincolors[SKINCOLOR_NOVA] = {
    name = "Nova",
    ramp = {0,160,192,194,184,185,185,168,169,253,254,254,254,254,30,31},
    invcolor = SKINCOLOR_SLADE,
    invshade = 7,
    chatcolor = V_BLUEMAP,
    accessible = true
}

skincolors[SKINCOLOR_TURQUOISE] = {
    name = "Turquoise",
    ramp = {0,120,140,141,125,125,126,143,138,138,159,253,139,254,254,31},
    invcolor = SKINCOLOR_PURPLE,
    invshade = 7,
    chatcolor = V_BLUEMAP,
    accessible = true
}

skincolors[SKINCOLOR_NOCTURNALBLUE] = {
    name = "Nocturnal Blue",
    ramp = {0,147,151,153,155,156,158,253,139,254,254,254,254,30,31,31},
    invcolor = SKINCOLOR_SUNNY,
    invshade = 7,
    chatcolor = V_BLUEMAP,
    accessible = true
}

skincolors[SKINCOLOR_GAMEBOY] = {
    name = "Game Boy",
    ramp = {54,73,112,255,151,181,35,54,73,112,255,152,181,35,54,73},
    invcolor = SKINCOLOR_BRAK,
    invshade = 7,
    chatcolor = V_CYANMAP,
    accessible = true
}

skincolors[SKINCOLOR_VIRUS] = {
    name = "Virus",
    ramp = {0,16,31,111,119,118,117,117,116,116,115,114,114,113,113,6},
    invcolor = SKINCOLOR_TROJAN,
    invshade = 7,
    chatcolor = V_GREENMAP,
    accessible = true
}

skincolors[SKINCOLOR_HEX] = {
    name = "Hex",
    ramp = {0,31,31,30,30,30,47,47,47,47,46,46,44,41,38,35},
    invcolor = SKINCOLOR_HEX,
    invshade = 7,
    chatcolor = V_REDMAP,
    accessible = true
}

skincolors[SKINCOLOR_TROJAN] = {
    name = "Trojan",
    ramp = {0,31,31,30,254,254,254,254,253,253,253,253,157,155,154,152},
    invcolor = SKINCOLOR_VIRUS,
    invshade = 7,
    chatcolor = V_BLUEMAP,
    accessible = true
}

skincolors[SKINCOLOR_VOID] = {
    name = "Void",
    ramp = {10,31,31,31,31,31,31,31,29,25,21,16,12,8,4,0},
    invcolor = SKINCOLOR_WHITE,
    invshade = 7,
    chatcolor = V_INVERTMAP,
    accessible = true
}

skincolors[SKINCOLOR_GLITZ] = {
    name = "Glitz",
    ramp = {0,176,178,180,181,182,183,204,205,215,69,69,79,237,69,58},
    invcolor = SKINCOLOR_ORANGE,
    invshade = 7,
    chatcolor = V_PINKMAP,
    accessible = true
}

skincolors[SKINCOLOR_HOTPINK] = {
    name = "Hot Pink",
    ramp = {0,200,201,202,203,34,34,204,205,205,205,206,206,207,207,207},
    invcolor = SKINCOLOR_GLITZ,
    invshade = 7,
    chatcolor = V_PINKMAP,
    accessible = true
}

skincolors[SKINCOLOR_EXPIREDMILK] = {
    name = "Expired Milk",
    ramp = {0,0,1,1,80,81,81,82,83,72,72,74,75,75,76,76},
    invcolor = SKINCOLOR_CORNFLOWER,
    invshade = 7,
    chatcolor = V_WHITEMAP,
    accessible = true
}

skincolors[SKINCOLOR_PLAINY] = {
    name = "Plainy",
    ramp = {80,90,100,115,115,116,116,117,117,118,109,109,110,110,111,31},
    invcolor = SKINCOLOR_COBALT,
    invshade = 7,
    chatcolor = V_GREENMAP,
    accessible = true
}

skincolors[SKINCOLOR_WINDY] = {
    name = "Windy",
    ramp = {80,80,80,1,1,0,0,128,129,130,131,134,135,135,135,151},
    invcolor = SKINCOLOR_JET,
    invshade = 7,
    chatcolor = V_WHITEMAP,
    accessible = true
}

skincolors[SKINCOLOR_HMS] = {
    name = "HYPER MYSTERIOUS COLONIC 123311",
    ramp = {73,73,112,112,73,73,73,73,73,73,73,73,73,73,73,73},
    invcolor = SKINCOLOR_HMS,
    invshade = 7,
    chatcolor = V_YELLOWMAP,
    accessible = true
}

skincolors[SKINCOLOR_STEELBOLT] = {
    name = "Steelbolt",
    ramp = {82,84,85,240,12,13,15,16,17,19,20,21,23,24,25,26},
    invcolor = SKINCOLOR_GREY,
    invshade = 7,
    chatcolor = V_GREYMAP,
    accessible = true
}

skincolors[SKINCOLOR_BLACKBERRY] = {
    name = "Blackberry",
    ramp = {160,193,195,168,169,169,169,169,169,169,187,187,254,254,30,31},
    invcolor = SKINCOLOR_GREY,
    invshade = 7,
    chatcolor = V_PURPLEMAP,
    accessible = true
}

skincolors[SKINCOLOR_OIL] = {
    name = "Oil",
    ramp = {73,75,76,77,79,239,30,31,31,31,31,31,31,31,31,31},
    invcolor = SKINCOLOR_GREEN,
    invshade = 7,
    chatcolor = V_YELLOWMAP,
    accessible = true
}

skincolors[SKINCOLOR_MOUTHWASH] = {
    name = "Mouthwash",
    ramp = {122,123,123,124,125,125,126,126,127,127,118,118,119,110,111,31},
    invcolor = SKINCOLOR_PURPLE,
    invshade = 7,
    chatcolor = V_GREENMAP,
    accessible = true
}

skincolors[SKINCOLOR_BERYL] = {
    name = "Beryl",
    ramp = {0,209,32,34,35,36,204,183,183,184,184,185,167,168,168,158},
    invcolor = SKINCOLOR_VAPOR,
    invshade = 7,
    chatcolor = V_REDMAP,
    accessible = true
}

skincolors[SKINCOLOR_APPLEJACK] = {
    name = "Applejack",
    ramp = {210,36,37,38,60,60,61,70,79,108,118,118,119,119,111,31},
    invcolor = SKINCOLOR_BREEZY,
    invshade = 7,
    chatcolor = V_REDMAP,
    accessible = true
}

skincolors[SKINCOLOR_BREEZY] = {
    name = "Breezy",
    ramp = {128,129,255,255,131,132,133,134,135,136,137,155,156,157,158,159},
    invcolor = SKINCOLOR_SKY,
    invshade = 0,
    chatcolor = V_SKYMAP,
    accessible = true
}

skincolors[SKINCOLOR_PRISTY] = {
    name = "Pristy",
    ramp = {0,1,3,88,88,89,89,90,97,98,100,101,103,104,116,31},
    invcolor = SKINCOLOR_BREEZY,
    invshade = 0,
    chatcolor = V_GREENMAP,
    accessible = true
}

skincolors[SKINCOLOR_PRISTY] = {
    name = "Cold",
    ramp = {0,128,129,131,133,135,151,153,154,155,156,158,159,253,254,31},
    invcolor = SKINCOLOR_PINK,
    invshade = 0,
    chatcolor = V_SKYMAP,
    accessible = true
}

skincolors[SKINCOLOR_FLICKERLIGHT] = {
    name = "Flicker",
    ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    invcolor = SKINCOLOR_FLICKERLIGHT,
    invshade = 7,
    chatcolor = V_BLACKMAP,
    accessible = true
}

skincolors[SKINCOLOR_FLUORERED] = {
    name = "Fluore Red",
    ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    invcolor = SKINCOLOR_LIGHTINGGREEN,
    invshade = 7,
    chatcolor = V_BLACKMAP,
    accessible = true
}

skincolors[SKINCOLOR_GLAZEBLUE] = {
    name = "Glazing Blue",
    ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    invcolor = SKINCOLOR_FLUORERED,
    invshade = 7,
    chatcolor = V_BLACKMAP,
    accessible = true
}

skincolors[SKINCOLOR_LIGHTINGGREEN] = {
    name = "Lighting Green",
    ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    invcolor = SKINCOLOR_FLUORERED,
    invshade = 7,
    chatcolor = V_BLACKMAP,
    accessible = true
}

local function Flicker()
    if (leveltime % 24) >= 0 and (leveltime % 24) <= 4
        skincolors[SKINCOLOR_FLICKERLIGHT].ramp = skincolors[SKINCOLOR_JET].ramp
		skincolors[SKINCOLOR_FLUORERED].ramp = skincolors[SKINCOLOR_SALMON].ramp
		skincolors[SKINCOLOR_GLAZEBLUE].ramp = skincolors[SKINCOLOR_CORNFLOWER].ramp
		skincolors[SKINCOLOR_LIGHTINGGREEN].ramp = skincolors[SKINCOLOR_MINT].ramp
    elseif (leveltime % 24) >= 4 and (leveltime % 24) <= 8
        skincolors[SKINCOLOR_FLICKERLIGHT].ramp = skincolors[SKINCOLOR_SILVER].ramp
		skincolors[SKINCOLOR_FLUORERED].ramp = skincolors[SKINCOLOR_FLAME].ramp
		skincolors[SKINCOLOR_GLAZEBLUE].ramp = skincolors[SKINCOLOR_BLUE].ramp
		skincolors[SKINCOLOR_LIGHTINGGREEN].ramp = skincolors[SKINCOLOR_EMERALD].ramp
    elseif (leveltime % 24) >= 8 and (leveltime % 24) <= 12
        skincolors[SKINCOLOR_FLICKERLIGHT].ramp = skincolors[SKINCOLOR_CLOUDY].ramp
		skincolors[SKINCOLOR_FLUORERED].ramp = skincolors[SKINCOLOR_RED].ramp
		skincolors[SKINCOLOR_GLAZEBLUE].ramp = skincolors[SKINCOLOR_COBALT].ramp
		skincolors[SKINCOLOR_LIGHTINGGREEN].ramp = skincolors[SKINCOLOR_GREEN].ramp
    elseif (leveltime % 24) >= 12 and (leveltime % 24) <= 16
        skincolors[SKINCOLOR_FLICKERLIGHT].ramp = skincolors[SKINCOLOR_WHITE].ramp
		skincolors[SKINCOLOR_FLUORERED].ramp = skincolors[SKINCOLOR_CRIMSON].ramp
		skincolors[SKINCOLOR_GLAZEBLUE].ramp = skincolors[SKINCOLOR_NOCTURNALBLUE].ramp
		skincolors[SKINCOLOR_LIGHTINGGREEN].ramp = skincolors[SKINCOLOR_FOREST].ramp
    elseif (leveltime % 24) >= 16 and (leveltime % 24) <= 20
        skincolors[SKINCOLOR_FLICKERLIGHT].ramp = skincolors[SKINCOLOR_CLOUDY].ramp
		skincolors[SKINCOLOR_FLUORERED].ramp = skincolors[SKINCOLOR_RED].ramp
		skincolors[SKINCOLOR_GLAZEBLUE].ramp = skincolors[SKINCOLOR_COBALT].ramp
		skincolors[SKINCOLOR_LIGHTINGGREEN].ramp = skincolors[SKINCOLOR_GREEN].ramp
    elseif (leveltime % 24) >= 20 and (leveltime % 24) <= 24
        skincolors[SKINCOLOR_FLICKERLIGHT].ramp = skincolors[SKINCOLOR_SILVER].ramp
		skincolors[SKINCOLOR_FLUORERED].ramp = skincolors[SKINCOLOR_FLAME].ramp
		skincolors[SKINCOLOR_GLAZEBLUE].ramp = skincolors[SKINCOLOR_BLUE].ramp
		skincolors[SKINCOLOR_LIGHTINGGREEN].ramp = skincolors[SKINCOLOR_EMERALD].ramp
    end
end

addHook("ThinkFrame", Flicker)
