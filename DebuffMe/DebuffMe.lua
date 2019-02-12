local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")
-----------------
---- Globals ----
-----------------
DebuffMe = {}
DebuffMe.name = "DebuffMe"
DebuffMe.version = "0.2"

DebuffMe.DebuffList = {
    [1] = "None",
	[2] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(38541)), --Taunt
	[3] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(17906)), --Crusher
	[4] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(75753)), --Alkosh
	[5] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(31104)), --EngFlames
    [6] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(62988)), --OffBalance
    [7] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(81519)), --Minor Vulnerability
    [8] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(80020)), --Minor LifeSteal
    [9] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(39100)), --Minor MagSteal    
    [10] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(17945)), --Weakening  
    [11] = zo_strformat(SI_ABILITY_NAME, GetAbilityName(21763)), --PotL 
}

DebuffMe.Abbreviation = {
    [1] = "",
	[2] = "TN", --Taunt
	[3] = "CR", --Crusher
	[4] = "AL", --Alkosh
	[5] = "EF", --EngFlames
    [6] = "OB", --OffBalance
    [7] = "IA", --Minor Vulnerability
    [8] = "ML", --Minor LifeSteal
    [9] = "MM", --Minor MagSteal    
    [10] = "WK", --Weakening  
    [11] = "PL", --PotL 
}
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
    AlwaysShowAlert = false
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
			text = "Description text here.",
		},
		[3] = {
			type = "dropdown",
			name = "Debuff Principal (milieu blanc)",
			tooltip = "Pas de virgules, ni d'abbréviation si debuff à 0.",
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
			name = "Debuff Secondaire (gauche bleu)",
			tooltip = "Un chiffre après la virgule, abbréviation si à 0.",
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
			name = "Debuff Secondaire (haut vert)",
			tooltip = "Un chiffre après la virgule, abbréviation si à 0.",
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
			name = "Debuff Secondaire (droite rouge)",
			tooltip = "Un chiffre après la virgule, abbréviation si à 0.",
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
			text = "Description text here.",
		},
        [9] = {
			type = "checkbox",
			name = "Devérouiller",
			tooltip = "Pour bouger les chiffres.",
			default = false,
			getFunc = function() return DebuffMe.savedVariables.AlwaysShowAlert end,
			setFunc = function(newValue) 
				DebuffMe.savedVariables.AlwaysShowAlert = newValue
				DebuffMeAlert:SetHidden(not newValue)  
			end,
		},
	}
	
	LAM2:RegisterOptionControls("DebuffMe_Settings", optionsData)
end

------------------
---- FONCTION ----
------------------
function DebuffMe.Calcul(Debuff_Choice)
    local currentTimeStamp = GetGameTimeMilliseconds() / 1000
    local Timer = 0
	local TimerTXT = ""
	
    for i=1,GetNumBuffs("reticleover") do --Verif temps debuff
		local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("reticleover",i)		
		if(zo_strformat(SI_ABILITY_NAME,GetAbilityName(abilityId)) == DebuffMe.DebuffList[Debuff_Choice]) then
			Timer = timeEnding - currentTimeStamp
		end
    end

    if (Timer <= 0) then 
        if Debuff_Choice == DebuffMe.Debuff_M then --pas d'abréviation si debuff principal
            TimerTXT = "0"
        else
            TimerTXT = DebuffMe.Abbreviation[Debuff_Choice] 
        end
    else
        if Debuff_Choice == DebuffMe.Debuff_M then --pas de virgule si debuff principal
            TimerTXT = tostring(string.format("%.0f", Timer))
        else
            TimerTXT = tostring(string.format("%.1f", Timer)) 
        end
    end
    return TimerTXT
end

----------------
---- UPDATE ----
----------------
function DebuffMe.Update()
    if (IsUnitInCombat("player")) then

        local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("reticleover", POWERTYPE_HEALTH)
		local TXT = ""
		
		DebuffMeAlert:SetHidden(false)

        if maxTargetHP >= 0 then
            if DebuffMe.Debuff_M ~= 1 then
                TXT = DebuffMe.Calcul(DebuffMe.Debuff_M)
                DebuffMeAlertMiddle:SetText(TXT)
                DebuffMeAlertMiddle:SetHidden(false)
            else 
                DebuffMeAlertMiddle:SetHidden(true)
            end

            if DebuffMe.Debuff_L ~= 1 then
                TXT = DebuffMe.Calcul(DebuffMe.Debuff_L)
                DebuffMeAlertLeft:SetText(TXT)
                DebuffMeAlertLeft:SetHidden(false)
            else 
                DebuffMeAlertLeft:SetHidden(true)
            end

            if DebuffMe.Debuff_T ~= 1 then
                TXT = DebuffMe.Calcul(DebuffMe.Debuff_T)
                DebuffMeAlertTop:SetText(TXT)
                DebuffMeAlertTop:SetHidden(false)
            else 
                DebuffMeAlertTop:SetHidden(true)
            end

            if DebuffMe.Debuff_R ~= 1 then
                TXT = DebuffMe.Calcul(DebuffMe.Debuff_R)
                DebuffMeAlertRight:SetText(TXT)
                DebuffMeAlertRight:SetHidden(false)
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

function DebuffMe:Initialize()
	--Settings
	DebuffMe.CreateSettingsWindow()
	--Saved Variables
	DebuffMe.savedVariables = ZO_SavedVars:New("DebuffMeVariables", 1, nil, DebuffMe.Default)
	EVENT_MANAGER:UnregisterForEvent(DebuffMe.name, EVENT_ADD_ON_LOADED)
	--UI
	DebuffMeAlert:SetHidden(true)
	DebuffMeAlert:ClearAnchors()
    DebuffMeAlert:SetAnchor(CENTER, GuiRoot, CENTER, DebuffMe.savedVariables.OffsetX, DebuffMe.savedVariables.OffsetY)

    DebuffMe.Debuff_M = DebuffMe.savedVariables.Debuff_M
    DebuffMe.Debuff_L = DebuffMe.savedVariables.Debuff_L
    DebuffMe.Debuff_T = DebuffMe.savedVariables.Debuff_T
    DebuffMe.Debuff_R = DebuffMe.savedVariables.Debuff_R
    
	EVENT_MANAGER:RegisterForUpdate(DebuffMe.name, 100, DebuffMe.Update)
	EVENT_MANAGER:RegisterForEvent(DebuffMe.name, EVENT_RETICLE_TARGET_CHANGED, DebuffMe.Update)
	EVENT_MANAGER:UnregisterForEvent(DebuffMe.name, EVENT_ADD_ON_LOADED)
end

function DebuffMe.SaveLoc()
	DebuffMe.savedVariables.OffsetX = DebuffMeAlertTaunt:GetLeft()
	DebuffMe.savedVariables.OffsetY = DebuffMeAlertTaunt:GetTop()
end	
 
function DebuffMe.OnAddOnLoaded(event, addonName)
	if addonName ~= DebuffMe.name then return end
		DebuffMe:Initialize()
end

EVENT_MANAGER:RegisterForEvent(DebuffMe.name, EVENT_ADD_ON_LOADED, DebuffMe.OnAddOnLoaded)
