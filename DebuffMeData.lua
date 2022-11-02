DebuffMe = DebuffMe or {}
local DebuffMe = DebuffMe

DebuffMe.DebuffList = {
    [1] = "None",
	[2] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(38541)), --Taunt
	[3] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(17906)), --Crusher
	[4] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(75753)), --Alkosh
	[5] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(31104)), --EngFlames
    [6] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(62988)), --OffBalance
    [7] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(81519)), --Minor Vulnerability
    [8] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(62504)), --Minor Maim
	[9] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(39100)), --Minor MagSteal    
	[10] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(88575)), --Minor LifeSteal    
    [11] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(17945)), --Weakening  
	[12] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(64144)), --Minor Fracture
	[13] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(68588)), --Minor Breach
	[14] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(62484)), --Major Fracture
	[15] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(62485)), --Major Breach
	[16] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(122397)), --Major Vulnerability
	[17] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(34384)), --Morag Tong
	[18] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(34734)), --Surprise Attack
}
--52788 Taunt immunity
--134599 OffBalance immunity
--68359 Minor Vulne (not IA)
--68368 Mino Maim (not W+S)
--80020  Minor Lifesteal
--41958 Green Altar
--41967 Red Altar

DebuffMe.TransitionTable = {
	[1] = 0,
	[2] = 38541, --Taunt
	[3] = 17906, --Crusher
	[4] = 75753, --Alkosh
	[5] = 31104, --EngFlames
    [6] = 62988, --OffBalance
    [7] = 81519, --Minor Vulnerability
    [8] = 62504, --Minor Maim
	[9] = 39100, --Minor MagSteal   
	[10] = 88575, --Minor LifeSteal 
    [11] = 17945, --Weakening  
	[12] = 64144, --Minor Fracture
	[13] = 68588, --Minor Breach
	[14] = 62484, --Major Fracture
	[15] = 62485, --Major Breach
	[16] = 122397, --Major Vulnerability
	[17] = 34384, --Morag Tong
	[18] = 34734, --Surprise Attack
}

DebuffMe.CustomAbilityNameWithID = {
	[38541] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(38541)), --Taunt
	[52788] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(52788)), --Taunt Immunity
	[17906] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(17906)), --Crusher
	[75753] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(75753)), --Alkosh
	[31104] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(31104)), --EngFlames
	[62988] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(62988)), --OffBalance
	[134599] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(134599)), --OffBalance Immunity
	[81519] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(81519)), --Minor Vulnerability
	[68359] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(68359)), --Minor Vulne (not IA)
    [68368] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(62504)), --Minor Maim
	[39100] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(39100)), --Minor MagSteal    
	[88575] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(88575)), --Minor LifeSteal    
    [17945] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(17945)), --Weakening  
	[64144] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(64144)), --Minor Fracture  
	[68588] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(68588)), --Minor Breach   
    [62484] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(62484)), --Major Fracture 
	[62485] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(62485)), --Major Breach 
	[122397] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(122397)), --Major Vulnerability 
	[34384] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(34384)), --Morag Tong
	[34734] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(34734)), --Surprise Attack
}

DebuffMe.Abbreviation = {
    [1] = "",
	[2] = "TN", --Taunt
	[3] = "CR", --Crusher
	[4] = "AL", --Alkosh
	[5] = "EF", --EngFlames
    [6] = "OB", --OffBalance
    [7] = "IA", --Minor Vulnerability
    [8] = "mM", --Minor Maim
	[9] = "mS", --Minor MagSteal    
	[10] = "mL", --Minor LifeSteal   
    [11] = "WK", --Weakening  
    [12] = "mF", --Minor Fracture
	[13] = "mB", --Minor Breach
	[14] = "MF", --Major Fracture
	[15] = "MB", --Major Breach
	[16] = "MV", --Major Vulnerability 
	[17] = "MT", --Morag Tong
	[18] = "SA", --Surprise Attack
}