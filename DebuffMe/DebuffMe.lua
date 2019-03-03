local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")
-----------------
---- Globals ----
-----------------
DebuffMe = {}
DebuffMe.name = "DebuffMe"
DebuffMe.version = "1.3.1"

DebuffMe.DebuffList = {
    [1] = "None",
	[2] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(38541)), --Taunt
	[3] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(17906)), --Crusher
	[4] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(75753)), --Alkosh
	[5] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(31104)), --EngFlames
    [6] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(62988)), --OffBalance
    [7] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(81519)), --Minor Vulnerability
    [8] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(68368)), --Minor Maim
    [9] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(39100)), --Minor MagSteal    
    [10] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(17945)), --Weakening  
    [11] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(21763)), --PotL 
} 
--52788 Taunt immunity
--102771 OffBalance immunity
--68359 Minor Vulne (not IA)
--80020 Minor Lifesteal

DebuffMe.TransitionTable = {
	[1] = 0,
	[2] = 38541, --Taunt
	[3] = 17906, --Crusher
	[4] = 75753, --Alkosh
	[5] = 31104, --EngFlames
    [6] = 62988, --OffBalance
    [7] = 81519, --Minor Vulnerability
    [8] = 68368, --Minor Maim
    [9] = 39100, --Minor MagSteal    
    [10] = 17945, --Weakening  
    [11] = 21763, --PotL 
}

DebuffMe.CustomAbilityNameWithID = {
	[38541] = GetAbilityName(38541), --Taunt
	[52788] = GetAbilityName(52788), --Taunt Immunity
	[17906] = GetAbilityName(17906), --Crusher
	[75753] = GetAbilityName(75753), --Alkosh
	[31104] = GetAbilityName(31104), --EngFlames
	[62988] = GetAbilityName(62988), --OffBalance
	[102771] = GetAbilityName(102771), --OffBalance Immunity
	[81519] = GetAbilityName(81519), --Minor Vulnerability
	[68359] = GetAbilityName(68359), --Minor Vulne (not IA)
    [68368] = GetAbilityName(68368), --Minor Maim
    [39100] = GetAbilityName(39100), --Minor MagSteal    
    [17945] = GetAbilityName(17945), --Weakening  
	[21763] = GetAbilityName(21763), --PotL 
}

local function GetFormattedAbilityNameWithID(id)	--Fix to LUI extended conflict thank you Solinur and Wheels
	local name = DebuffMe.CustomAbilityNameWithID[id] or zo_strformat(SI_ABILITY_NAME, GetAbilityName(id))
	return name
end 

DebuffMe.Abbreviation = {
    [1] = "",
	[2] = "TN", --Taunt
	[3] = "CR", --Crusher
	[4] = "AL", --Alkosh
	[5] = "EF", --EngFlames
    [6] = "OB", --OffBalance
    [7] = "IA", --Minor Vulnerability
    [8] = "MM", --Minor Maim
    [9] = "MS", --Minor MagSteal    
    [10] = "WK", --Weakening  
    [11] = "PL", --PotL 
}

DebuffMe.flag_immunity = false
---------------------------
---- Variables Default ----
---------------------------
DebuffMe.Default = {
	OffsetX = 0,
	OffsetY = 0,
    Debuff_M = 2,
    Debuff_L = 4,
    Debuff_T = 3, 
    Debuff_R = 5,
    AlwaysShowAlert = false,
	FontSize = 36,
	Spacing = 10
}

-------------------------
---- Settings Window ----
-------------------------
function DebuffMe.CreateSettingsWindow()
	local panelData = {
		type = "panel",
		name = "DebuffMe",
		displayName = "DebuffMe",
		author = "Floliroy",
		version = DebuffMe.version,
		slashCommand = "/dbuffme",
		registerForRefresh = true,
		registerForDefaults = true,
	}
	
	local cntrlOptionsPanel = LAM2:RegisterAddonPanel("DebuffMe_Settings", panelData)
	
	local optionsData = {
		[1] = {
			type = "header",
			name = "DebuffMe Settings",
		},
		[2] = {
			type = "description",
			text = "Choose here which debuff you want to show.",
		},
		[3] = {
			type = "dropdown",
			name = "Main Debuff (Middle White)",
			tooltip = "No number after the decimal point, neither abbreviation if debuff at 0.",
			choices = DebuffMe.DebuffList,
			default = DebuffMe.DebuffList[2],
			getFunc = function() return DebuffMe.DebuffList[DebuffMe.savedVariables.Debuff_M] end,
			setFunc = function(selected)
				for index, name in ipairs(DebuffMe.DebuffList) do
					if name == selected then
						DebuffMe.savedVariables.Debuff_M = index
						DebuffMe.Debuff_M = index
						break
					end
				end
			end,
		},
        [4] = {
			type = "dropdown",
			name = "Secondary Debuff (Left Blue)",
			tooltip = "One number after the decimal point, and abbreviation if debuff at 0.",
			choices = DebuffMe.DebuffList,
			default = DebuffMe.DebuffList[4],
			getFunc = function() return DebuffMe.DebuffList[DebuffMe.savedVariables.Debuff_L] end,
			setFunc = function(selected)
				for index, name in ipairs(DebuffMe.DebuffList) do
					if name == selected then
						DebuffMe.savedVariables.Debuff_L = index
						DebuffMe.Debuff_L = index
						break
					end
				end
			end,
		},
        [5] = {
			type = "dropdown",
			name = "Secondary Debuff (Top Green)",
			tooltip = "One number after the decimal point, and abbreviation if debuff at 0.",
			choices = DebuffMe.DebuffList,
			default = DebuffMe.DebuffList[3],
			getFunc = function() return DebuffMe.DebuffList[DebuffMe.savedVariables.Debuff_T] end,
			setFunc = function(selected)
				for index, name in ipairs(DebuffMe.DebuffList) do
					if name == selected then
						DebuffMe.savedVariables.Debuff_T = index
						DebuffMe.Debuff_T = index
						break
					end
				end
			end,
		},
        [6] = {
			type = "dropdown",
			name = "Secondary Debuff (Right Red)",
			tooltip = "One number after the decimal point, and abbreviation if debuff at 0.",
			choices = DebuffMe.DebuffList,
			default = DebuffMe.DebuffList[5],
			getFunc = function() return DebuffMe.DebuffList[DebuffMe.savedVariables.Debuff_R] end,
			setFunc = function(selected)
				for index, name in ipairs(DebuffMe.DebuffList) do
					if name == selected then
						DebuffMe.savedVariables.Debuff_R = index
						DebuffMe.Debuff_R = index
						break
					end
				end
			end,
		},
        [7] = {
			type = "header",
			name = "DebuffMe Graphics",
		},
		[8] = {
			type = "description",
			text = "More coming soon !",
		},
		[9] = {
			type = "button",
			name = "Reset Position",
			tooltip = "Reset the position of the timers at their initial position: center of your screen.",
			func = function()
				DebuffMe.savedVariables.OffsetX = 0
				DebuffMe.savedVariables.OffsetY = 0
				DebuffMeAlert:SetAnchor(CENTER, GuiRoot, CENTER, DebuffMe.savedVariables.OffsetX, DebuffMe.savedVariables.OffsetY)
			end,
			width = "half",
		},
        [10] = {
			type = "checkbox",
			name = "Unlock",
			tooltip = "Use it to move the timers.",
			default = false,
			getFunc = function() return DebuffMe.savedVariables.AlwaysShowAlert end,
			setFunc = function(newValue) 
				DebuffMe.savedVariables.AlwaysShowAlert = newValue
				DebuffMeAlert:SetHidden(not newValue)  
			end,
		},
		[11] = {
            type = "slider",
            name = "Font Size",
            tooltip = "Choose here the size of the text, the middle debuff will be a bit smaller.",
            getFunc = function() return DebuffMe.savedVariables.FontSize end,
            setFunc = function(newValue) 
				DebuffMe.savedVariables.FontSize = newValue 
				DebuffMe.SetFontSize(DebuffMeAlertMiddle, (newValue * 0.9))
				DebuffMe.SetFontSize(DebuffMeAlertLeft, newValue)
				DebuffMe.SetFontSize(DebuffMeAlertTop, newValue)
				DebuffMe.SetFontSize(DebuffMeAlertRight, newValue)
			end,
            min = 20,
            max = 72,
            step = 2,
            default = 36,
            width = "full",
		  },
		  [12] = {
            type = "slider",
            name = "Spacing",
            tooltip = "Choose here the spacing between the different timers.",
            getFunc = function() return DebuffMe.savedVariables.Spacing end,
            setFunc = function(newValue) 
				DebuffMe.savedVariables.Spacing = newValue 
				DebuffMeAlertLeft:SetAnchor(CENTER, DebuffMeAlertMiddle, CENTER, -8*DebuffMe.savedVariables.Spacing, DebuffMe.savedVariables.Spacing)
				DebuffMeAlertTop:SetAnchor(CENTER, DebuffMeAlertMiddle, CENTER, 0, -6*DebuffMe.savedVariables.Spacing)
				DebuffMeAlertRight:SetAnchor(CENTER, DebuffMeAlertMiddle, CENTER, 8*DebuffMe.savedVariables.Spacing, DebuffMe.savedVariables.Spacing)
			end,
            min = 3,
            max = 30,
            step = 1,
            default = 10,
            width = "full",
          },
	}
	
	LAM2:RegisterOptionControls("DebuffMe_Settings", optionsData)
end

------------------
---- FONCTION ----
------------------
function DebuffMe.Calcul(Debuff_Choice)
	local currentTimeStamp = GetGameTimeMilliseconds() / 1000
	DebuffID = DebuffMe.TransitionTable[Debuff_Choice]

    local Timer = 0
	local TimerTXT = ""
	DebuffMe.flag_immunity = false
	
    for i=1,GetNumBuffs("reticleover") do --check all debuffs
		local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("reticleover",i)		
		if Debuff_Choice == 2 then --if taunt
			if castByPlayer == true then
				if GetFormattedAbilityNameWithID(abilityId) == GetFormattedAbilityNameWithID(DebuffID) then 
					Timer = timeEnding - currentTimeStamp
				end
			end
		else 
			if GetFormattedAbilityNameWithID(abilityId) == GetFormattedAbilityNameWithID(DebuffID) then
				Timer = timeEnding - currentTimeStamp
			end
		end
	end

	if (Timer == 0) and (Debuff_Choice == 2) then --check target taunt immunity 
		for i=1,GetNumBuffs("reticleover") do 
			local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("reticleover",i)
			if GetFormattedAbilityNameWithID(abilityId) == GetFormattedAbilityNameWithID(52788) then 
				Timer = timeEnding - currentTimeStamp
				DebuffMe.flag_immunity = true
			end
		end
	end
	if (Timer == 0) and (Debuff_Choice == 6) then --check target offbalance immunity 
		for i=1,GetNumBuffs("reticleover") do 
			local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("reticleover",i)
			if GetFormattedAbilityNameWithID(abilityId) == GetFormattedAbilityNameWithID(102771) then 
				Timer = timeEnding - currentTimeStamp
				DebuffMe.flag_immunity = true
			end
		end
	end
	if (Timer <= 4) and (Debuff_Choice == 7) then --check minor vulnerability (not IA)
		for i=1,GetNumBuffs("reticleover") do 
			local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("reticleover",i)
			if GetFormattedAbilityNameWithID(abilityId) == GetFormattedAbilityNameWithID(68359) then 
				Timer = timeEnding - currentTimeStamp
			end
		end
	end

    if (Timer <= 0) then 
        if Debuff_Choice == DebuffMe.Debuff_M then --no abbreviation if main debuff
            TimerTXT = "0"
        else
            TimerTXT = DebuffMe.Abbreviation[Debuff_Choice] 
        end
    else
        if Debuff_Choice == DebuffMe.Debuff_M then --no decimal point if main debuff
            TimerTXT = tostring(string.format("%.0f", Timer))
        else
            TimerTXT = tostring(string.format("%.1f", Timer)) 
        end
    end
    return TimerTXT
end

function DebuffMe.SetFontSize(label, size)
	local path = "EsoUI/Common/Fonts/univers67.otf"
    local outline = "soft-shadow-thick"
    label:SetFont(path .. "|" .. size .. "|" .. outline)
end

----------------
---- UPDATE ----
----------------
function DebuffMe.Update()
	--d("X: " ..DebuffMe.savedVariables.OffsetX .. " Y: " .. DebuffMe.savedVariables.OffsetY)
	if (IsUnitInCombat("player")) then

        local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("reticleover", POWERTYPE_HEALTH)
		local TXT = ""
		
		DebuffMeAlert:SetHidden(false)

        if maxTargetHP >= 1000000 then
            if DebuffMe.Debuff_M ~= 1 then
                TXT = DebuffMe.Calcul(DebuffMe.Debuff_M)
                DebuffMeAlertMiddle:SetText(TXT)
				DebuffMeAlertMiddle:SetHidden(false)
				if (DebuffMe.flag_immunity == true) then
					DebuffMeAlertMiddle:SetColor(unpack{1,0,0}) --red if immun
				else 
					DebuffMeAlertMiddle:SetColor(unpack{1,1,1}) --original color else (FFFFFF)
				end
            else 
                DebuffMeAlertMiddle:SetHidden(true)
            end

            if DebuffMe.Debuff_L ~= 1 then
                TXT = DebuffMe.Calcul(DebuffMe.Debuff_L)
                DebuffMeAlertLeft:SetText(TXT)
				DebuffMeAlertLeft:SetHidden(false)
				if (DebuffMe.flag_immunity == true) then
					DebuffMeAlertLeft:SetColor(unpack{1,0,0}) --red if immun
				else 
					DebuffMeAlertLeft:SetColor(unpack{0,(170/255),1}) --original color else (00AAFF)
				end
            else 
                DebuffMeAlertLeft:SetHidden(true)
            end

            if DebuffMe.Debuff_T ~= 1 then
                TXT = DebuffMe.Calcul(DebuffMe.Debuff_T)
                DebuffMeAlertTop:SetText(TXT)
                DebuffMeAlertTop:SetHidden(false)
				if (DebuffMe.flag_immunity == true) then
					DebuffMeAlertTop:SetColor(unpack{1,0,0}) --red if immun
				else 
					DebuffMeAlertTop:SetColor(unpack{(56/255),(195/255),0}) --original color else (38C300)
				end
            else 
                DebuffMeAlertTop:SetHidden(true)
            end

            if DebuffMe.Debuff_R ~= 1 then
                TXT = DebuffMe.Calcul(DebuffMe.Debuff_R)
                DebuffMeAlertRight:SetText(TXT)
                DebuffMeAlertRight:SetHidden(false)
				if (DebuffMe.flag_immunity == true) then
					DebuffMeAlertRight:SetColor(unpack{1,0,0}) --red if immun
				else 
					DebuffMeAlertRight:SetColor(unpack{(236/255),(60/255),0}) --original color else (EC3C00)
				end
            else 
                DebuffMeAlertRight:SetHidden(true)
            end
        else
            DebuffMeAlert:SetHidden(true)
        end
    else
        DebuffMeAlert:SetHidden(not DebuffMe.savedVariables.AlwaysShowAlert)
    end
end

--------------
---- INIT ----
--------------

function DebuffMe:Initialize()
	--Settings
	DebuffMe.CreateSettingsWindow()
	--Saved Variables
	DebuffMe.savedVariables = ZO_SavedVars:New("DebuffMeVariables", 1, nil, DebuffMe.Default)
	EVENT_MANAGER:UnregisterForEvent(DebuffMe.name, EVENT_ADD_ON_LOADED)
	--UI
	DebuffMeAlert:SetHidden(true)
	DebuffMeAlert:ClearAnchors()
	if (DebuffMe.savedVariables.OffsetX ~= 0) and (DebuffMe.savedVariables.OffsetY ~= 0) then 	--recover last position
		DebuffMeAlert:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, DebuffMe.savedVariables.OffsetX, DebuffMe.savedVariables.OffsetY)
	else																						--initial position (center)
		DebuffMeAlert:SetAnchor(CENTER, GuiRoot, CENTER, DebuffMe.savedVariables.OffsetX, DebuffMe.savedVariables.OffsetY)
	end
	
	DebuffMeAlertLeft:SetAnchor(CENTER, DebuffMeAlertMiddle, CENTER, -8*DebuffMe.savedVariables.Spacing, DebuffMe.savedVariables.Spacing)
	DebuffMeAlertTop:SetAnchor(CENTER, DebuffMeAlertMiddle, CENTER, 0, -6*DebuffMe.savedVariables.Spacing)
	DebuffMeAlertRight:SetAnchor(CENTER, DebuffMeAlertMiddle, CENTER, 8*DebuffMe.savedVariables.Spacing, DebuffMe.savedVariables.Spacing)

	DebuffMe.SetFontSize(DebuffMeAlertMiddle, (DebuffMe.savedVariables.FontSize * 0.9))
	DebuffMe.SetFontSize(DebuffMeAlertLeft, DebuffMe.savedVariables.FontSize)
	DebuffMe.SetFontSize(DebuffMeAlertTop, DebuffMe.savedVariables.FontSize)
	DebuffMe.SetFontSize(DebuffMeAlertRight, DebuffMe.savedVariables.FontSize)

	--Main
    DebuffMe.Debuff_M = DebuffMe.savedVariables.Debuff_M
    DebuffMe.Debuff_L = DebuffMe.savedVariables.Debuff_L
    DebuffMe.Debuff_T = DebuffMe.savedVariables.Debuff_T
    DebuffMe.Debuff_R = DebuffMe.savedVariables.Debuff_R
    
	EVENT_MANAGER:RegisterForUpdate(DebuffMe.name, 100, DebuffMe.Update)
	EVENT_MANAGER:RegisterForEvent(DebuffMe.name, EVENT_RETICLE_TARGET_CHANGED, DebuffMe.Update)
	EVENT_MANAGER:UnregisterForEvent(DebuffMe.name, EVENT_ADD_ON_LOADED)
end

function DebuffMe.SaveLoc()
	DebuffMe.savedVariables.OffsetX = DebuffMeAlert:GetLeft()
	DebuffMe.savedVariables.OffsetY = DebuffMeAlert:GetTop()
end	
 
function DebuffMe.OnAddOnLoaded(event, addonName)
	if addonName ~= DebuffMe.name then return end
		DebuffMe:Initialize()
end

EVENT_MANAGER:RegisterForEvent(DebuffMe.name, EVENT_ADD_ON_LOADED, DebuffMe.OnAddOnLoaded)