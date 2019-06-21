local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")
-----------------
---- Globals ----
-----------------
DebuffMe = DebuffMe or {}
local DebuffMe = DebuffMe

DebuffMe.name = "DebuffMe"
DebuffMe.version = "1.4.0"

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
--102771 OffBalance immunity
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
	[38541] = GetAbilityName(38541), --Taunt
	[52788] = GetAbilityName(52788), --Taunt Immunity
	[17906] = GetAbilityName(17906), --Crusher
	[75753] = GetAbilityName(75753), --Alkosh
	[31104] = GetAbilityName(31104), --EngFlames
	[62988] = GetAbilityName(62988), --OffBalance
	[102771] = GetAbilityName(102771), --OffBalance Immunity
	[81519] = GetAbilityName(81519), --Minor Vulnerability
	[68359] = GetAbilityName(68359), --Minor Vulne (not IA)
    [68368] = GetAbilityName(62504), --Minor Maim
	[39100] = GetAbilityName(39100), --Minor MagSteal    
	[88575] = GetAbilityName(88575), --Minor LifeSteal    
    [17945] = GetAbilityName(17945), --Weakening  
	[64144] = GetAbilityName(64144), --Minor Fracture  
	[68588] = GetAbilityName(68588), --Minor Breach   
    [62484] = GetAbilityName(62484), --Major Fracture 
	[62485] = GetAbilityName(62485), --Major Breach 
	[122397] = GetAbilityName(122397), --Major Vulnerability 
	[34384] = GetAbilityName(34384), --Morag Tong
	[34734] = GetAbilityName(34734), --Surprise Attack
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

DebuffMe.flag_immunity = false
DebuffMe.altarEndTime = 0
---------------------------
---- Variables Default ----
---------------------------
DebuffMe.Default = {
	OffsetX = 0,
	OffsetY = 0,
	Debuff_Show = {	[1] = 2,
					[2] = 4,
					[3] = 3,
					[4] = 5},
    AlwaysShowAlert = false,
	FontSize = 36,
	Spacing = 10,
	SlowMode = false,
}

-------------------------
---- Settings Window ----
-------------------------
function DebuffMe.CreateSettingsWindow()
	local panelData = {
		type = "panel",
		name = "DebuffMe",
		displayName = "Debuff|cec3c00Me|r",
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
			getFunc = function() return DebuffMe.DebuffList[DebuffMe.savedVariables.Debuff_Show[1]] end,
			setFunc = function(selected)
				for index, name in ipairs(DebuffMe.DebuffList) do
					if name == selected then
						DebuffMe.savedVariables.Debuff_Show[1] = index
						DebuffMe.Debuff_Show[1] = index
						break
					end
				end
			end,
			scrollable = true,
		},
        [4] = {
			type = "dropdown",
			name = "Secondary Debuff (Left Blue)",
			tooltip = "One number after the decimal point, and abbreviation if debuff at 0.",
			choices = DebuffMe.DebuffList,
			default = DebuffMe.DebuffList[4],
			getFunc = function() return DebuffMe.DebuffList[DebuffMe.savedVariables.Debuff_Show[2]] end,
			setFunc = function(selected)
				for index, name in ipairs(DebuffMe.DebuffList) do
					if name == selected then
						DebuffMe.savedVariables.Debuff_Show[2] = index
						DebuffMe.Debuff_Show[2] = index
						break
					end
				end
			end,
			scrollable = true,
		},
        [5] = {
			type = "dropdown",
			name = "Secondary Debuff (Top Green)",
			tooltip = "One number after the decimal point, and abbreviation if debuff at 0.",
			choices = DebuffMe.DebuffList,
			default = DebuffMe.DebuffList[3],
			getFunc = function() return DebuffMe.DebuffList[DebuffMe.savedVariables.Debuff_Show[3]] end,
			setFunc = function(selected)
				for index, name in ipairs(DebuffMe.DebuffList) do
					if name == selected then
						DebuffMe.savedVariables.Debuff_Show[3] = index
						DebuffMe.Debuff_Show[3] = index
						break
					end
				end
			end,
			scrollable = true,
		},
        [6] = {
			type = "dropdown",
			name = "Secondary Debuff (Right Red)",
			tooltip = "One number after the decimal point, and abbreviation if debuff at 0.",
			choices = DebuffMe.DebuffList,
			default = DebuffMe.DebuffList[5],
			getFunc = function() return DebuffMe.DebuffList[DebuffMe.savedVariables.Debuff_Show[4]] end,
			setFunc = function(selected)
				for index, name in ipairs(DebuffMe.DebuffList) do
					if name == selected then
						DebuffMe.savedVariables.Debuff_Show[4] = index
						DebuffMe.Debuff_Show[4] = index
						break
					end
				end
			end,
			scrollable = true,
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
		  [13] = {
			type = "checkbox",
			name = "Slow Mode",
			tooltip = "The addon will take less performance on your computer, but timers will not have any numbers after decimal points.",
			default = false,
			getFunc = function() return DebuffMe.savedVariables.SlowMode end,
			setFunc = function(newValue) 
				DebuffMe.savedVariables.SlowMode = newValue
				DebuffMe.SlowMode = newValue
				DebuffMe.EventRegister()
			end,
		},
	}
	
	LAM2:RegisterOptionControls("DebuffMe_Settings", optionsData)
end

------------------
---- FONCTION ----
------------------
function DebuffMe.DoesDebuffEquals(ID1, ID2)
	if GetFormattedAbilityNameWithID(ID1) == GetFormattedAbilityNameWithID(ID2) then 
		return true
	else
		return false
	end
end

function DebuffMe.Calcul(index)
	local Debuff_Choice = DebuffMe.Debuff_Show[index]
	local currentTimeStamp = GetGameTimeMilliseconds() / 1000
	DebuffID = DebuffMe.TransitionTable[Debuff_Choice]

    local Timer = 0
	DebuffMe.flag_immunity = false
	
	for i=1, GetNumBuffs("reticleover") do --check all debuffs
		local _, _, timeEnding, _, _, _, _, _, _, _, abilityId, _, castByPlayer = GetUnitBuffInfo("reticleover",i)		
		if Debuff_Choice == 2 then --if taunt
			if castByPlayer == true then
				if DebuffMe.DoesDebuffEquals(abilityId, DebuffID) then 
					Timer = timeEnding - currentTimeStamp
				end
			end
		else 
			if DebuffMe.DoesDebuffEquals(abilityId, DebuffID) then
				if Timer <= timeEnding - currentTimeStamp then --ignore conflict when more than one player is applying the same debuff
					Timer = timeEnding - currentTimeStamp
				end
			end
		end
	end

	--------------------
	-- SPECIAL TIMERS --
	--------------------
		----------------
		-- IMMUNITIES --
		----------------
	if Timer <= 0 and Debuff_Choice == 2 then --check target taunt immunity 
		for i=1,GetNumBuffs("reticleover") do 
			local _, _, timeEnding, _, _, _, _, _, _, _, abilityId, _, _ = GetUnitBuffInfo("reticleover",i)
			if DebuffMe.DoesDebuffEquals(abilityId, 52788) then 
				Timer = timeEnding - currentTimeStamp
				DebuffMe.flag_immunity = true
			end
		end
	end
	if Timer <= 0 and Debuff_Choice == 6 then --check target offbalance immunity 
		for i=1,GetNumBuffs("reticleover") do 
			local _, _, timeEnding, _, _, _, _, _, _, _, abilityId, _, _ = GetUnitBuffInfo("reticleover",i)
			if DebuffMe.DoesDebuffEquals(abilityId, 102771) then 
				Timer = timeEnding - currentTimeStamp
				DebuffMe.flag_immunity = true
			end
		end
	end
		-------------------
		-- VULNERABILITY --
		-------------------
	if Timer <= 4 and Debuff_Choice == 7 then --check minor vulnerability from shock
		for i=1,GetNumBuffs("reticleover") do 
			local _, _, timeEnding, _, _, _, _, _, _, _, abilityId, _, _ = GetUnitBuffInfo("reticleover",i)
			if DebuffMe.DoesDebuffEquals(abilityId, 68359) then 
				Timer = timeEnding - currentTimeStamp
			end
		end
	end
	if Timer <= 8 and Debuff_Choice == 7 then --check minor vulnerability from nb gap closer
		for i=1,GetNumBuffs("reticleover") do 
			local _, _, timeEnding, _, _, _, _, _, _, _, abilityId, _, _ = GetUnitBuffInfo("reticleover",i)
			if DebuffMe.DoesDebuffEquals(abilityId, 124806) then 
				if Timer <= timeEnding - currentTimeStamp then
					Timer = timeEnding - currentTimeStamp
				end
			end
		end
	end
	if Timer <= 4 and Debuff_Choice == 8 then --check minor main from chilled
		for i=1,GetNumBuffs("reticleover") do 
			local _, _, timeEnding, _, _, _, _, _, _, _, abilityId, _, _ = GetUnitBuffInfo("reticleover",i)
			if DebuffMe.DoesDebuffEquals(abilityId, 68368) then 
				Timer = timeEnding - currentTimeStamp
			end
		end
	end	
		---------------------
		-- MINOR LIFESTEAL --
		---------------------
	if Debuff_Choice == 10 and Timer <= DebuffMe.altarEndTime - currentTimeStamp then --check minor lifesteal from altar
		for i=1,GetNumBuffs("reticleover") do 
			local _, _, _, _, _, _, _, _, _, _, abilityId, _, _ = GetUnitBuffInfo("reticleover",i)
			if DebuffMe.DoesDebuffEquals(abilityId, 80020) then --altar
				Timer = DebuffMe.altarEndTime - currentTimeStamp
			end
		end
	end	

	---------------------
	-- CONVERT TO TEXT --
	---------------------
	local TimerTXT = ""

    if Timer <= 0 then 
        if index == 1 then --no abbreviation if main debuff
            TimerTXT = "0"
        else
            TimerTXT = DebuffMe.Abbreviation[Debuff_Choice] 
        end
    else
        if index == 1 then --no decimal point if main debuff
            TimerTXT = tostring(string.format("%.0f", Timer))
        else
			if DebuffMe.SlowMode == true then
				TimerTXT = tostring(string.format("%.0f", Timer))
			else
				TimerTXT = tostring(string.format("%.1f", Timer)) 
			end
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
function DebuffMe.AltarTimer(_, changeType, _, _, _, _, endTime, _, _, _, _, _, _, _, _, abilityId, _)
	if changeType == COMBAT_UNIT_TYPE_PLAYER and abilityId == 39489 or 41967 or 41958 then
		local currentTimeStamp = endTime - GetGameTimeMilliseconds() / 1000
		if currentTimeStamp > 0 then
			DebuffMe.altarEndTime = endTime
		end
	end 
end

function DebuffMe.SetText(index, txt)
	if index == 1 then
		DebuffMeAlertMiddle:SetText(txt)
	elseif index == 2 then
		DebuffMeAlertLeft:SetText(txt)
	elseif index == 3 then
		DebuffMeAlertTop:SetText(txt)
	elseif index == 4 then
		DebuffMeAlertRight:SetText(txt)
	end
end

function DebuffMe.SetHidden(index, hide)
	if index == 1 then
		DebuffMeAlertMiddle:SetHidden(hide)
	elseif index == 2 then
		DebuffMeAlertLeft:SetHidden(hide)
	elseif index == 3 then
		DebuffMeAlertTop:SetHidden(hide)
	elseif index == 4 then
		DebuffMeAlertRight:SetHidden(hide)
	end
end

function DebuffMe.SetColor(index, immun)
	if index == 1 then
		if immun then 
			DebuffMeAlertMiddle:SetColor(unpack{1,0,0})
		else
			DebuffMeAlertMiddle:SetColor(unpack{1,1,1}) --FFFFFF
		end
	elseif index == 2 then
		if immun then 
			DebuffMeAlertLeft:SetColor(unpack{1,0,0})
		else
			DebuffMeAlertLeft:SetColor(unpack{0,(170/255),1}) --00AAFF
		end
	elseif index == 3 then
		if immun then 
			DebuffMeAlertTop:SetColor(unpack{1,0,0})
		else
			DebuffMeAlertTop:SetColor(unpack{(56/255),(195/255),0}) --38C300
		end
	elseif index == 4 then
		if immun then 
			DebuffMeAlertRight:SetColor(unpack{1,0,0})
		else
			DebuffMeAlertRight:SetColor(unpack{(236/255),(60/255),0}) --EC3C00
		end
	end
end

function DebuffMe.Update()
	local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("reticleover", POWERTYPE_HEALTH)
	local TXT = ""
	
	DebuffMeAlert:SetHidden(false)

	if maxTargetHP >= 1000000 then --only if target got more than 1M hp
		for index = 1, #DebuffMe.Debuff_Show do
			if DebuffMe.Debuff_Show[index] ~= 1 then
				TXT = DebuffMe.Calcul(index)

				DebuffMe.SetText(index, TXT)
				DebuffMe.SetHidden(index, false)

				DebuffMe.SetColor(index, DebuffMe.flag_immunity)
			else 
				DebuffMe.SetHidden(index, true)
			end
		end
	else
		DebuffMeAlert:SetHidden(true)
	end
    
end

function DebuffMe.EventRegister()	

	EVENT_MANAGER:UnregisterForUpdate(DebuffMe.name .. "Update")

	if IsUnitInCombat("player") then
		if DebuffMe.SlowMode then
			EVENT_MANAGER:RegisterForUpdate(DebuffMe.name .. "Update", 333, DebuffMe.Update)
		else
			EVENT_MANAGER:RegisterForUpdate(DebuffMe.name .. "Update", 100, DebuffMe.Update)
		end
	else
        DebuffMeAlert:SetHidden(not DebuffMe.savedVariables.AlwaysShowAlert)
    end
end

--------------
---- INIT ----
--------------

function DebuffMe.InitUI()
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
end

function DebuffMe.GetSavedFor1_4()
	DebuffMe.Debuff_Show[1] = DebuffMe.savedVariables.Debuff_M
	DebuffMe.Debuff_Show[2] = DebuffMe.savedVariables.Debuff_L
	DebuffMe.Debuff_Show[3] = DebuffMe.savedVariables.Debuff_T
	DebuffMe.Debuff_Show[4] = DebuffMe.savedVariables.Debuff_R
	DebuffMe.savedVariables.Debuff_Show = DebuffMe.Debuff_Show
	
	DebuffMe.savedVariables.Debuff_M = nil
	DebuffMe.savedVariables.Debuff_L = nil 
	DebuffMe.savedVariables.Debuff_T = nil 
	DebuffMe.savedVariables.Debuff_R = nil 
end

function DebuffMe:Initialize()
	--Settings
	DebuffMe.CreateSettingsWindow()
	--Saved Variables
	DebuffMe.savedVariables = ZO_SavedVars:New("DebuffMeVariables", 1, nil, DebuffMe.Default)
	--UI
	DebuffMe.InitUI()
	--Variables
	DebuffMe.Debuff_Show = DebuffMe.savedVariables.Debuff_Show
	DebuffMe.SlowMode = DebuffMe.savedVariables.SlowMode

	if DebuffMe.savedVariables.Debuff_M ~= nil and DebuffMe.savedVariables.Debuff_L ~= nil 
	and DebuffMe.savedVariables.Debuff_T ~= nil and DebuffMe.savedVariables.Debuff_R ~= nil then
		--get the previous values
		DebuffMe.GetSavedFor1_4()
	end
	
	--Events
	EVENT_MANAGER:RegisterForEvent(DebuffMe.name, EVENT_RETICLE_TARGET_CHANGED, DebuffMe.EventRegister)
	EVENT_MANAGER:RegisterForEvent(DebuffMe.name, EVENT_PLAYER_ACTIVATED, DebuffMe.EventRegister)
	EVENT_MANAGER:RegisterForEvent(DebuffMe.name, EVENT_PLAYER_COMBAT_STATE, DebuffMe.EventRegister)

	local altarID = {39489, 41967, 41958}
	for i = 1, #altarID do
		EVENT_MANAGER:RegisterForEvent(DebuffMe.name .. "Altar" .. i, EVENT_EFFECT_CHANGED, DebuffMe.AltarTimer)
		EVENT_MANAGER:AddFilterForEvent(DebuffMe.name .. "Altar" .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, altarID[i])
	end	

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