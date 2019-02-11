--local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")
-----------------
---- Globals ----
-----------------
DebuffMe = {}
DebuffMe.name = "DebuffMe"
DebuffMe.version = "0.1"

DebuffMe.EngFlames = 0
DebuffMe.Alkosh = 0
DebuffMe.Crusher = 0
DebuffMe.Taunt = 0
---------------------------
---- Variables Default ----
---------------------------
DebuffMe.Default = {
	OffsetX = 0,
	OffsetY = 0
}

-------------------------
---- Settings Window ----
-------------------------

--Todo

----------------
---- UPDATE ----
----------------
function DebuffMe.Update()
    if 1 then --a modifier avec (IsUnitInCombat("player"))
        local currentTimeStamp = GetGameTimeMilliseconds() / 1000

        DebuffMe.EngFlames = 0
        DebuffMe.Crusher = 0
        DebuffMe.Alkosh = 0
        DebuffMe.Taunt = 0
        --Check for Debuffs
        for i=1,GetNumBuffs("reticleover") do --Verif Engulf
			local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("reticleover",i)		
			if(zo_strformat(SI_ABILITY_NAME,GetAbilityName(abilityId)) == zo_strformat(SI_ABILITY_NAME, GetAbilityName(31104))) then
                DebuffMe.EngFlames = timeEnding - currentTimeStamp
			end
        end
        for i=1,GetNumBuffs("reticleover") do --Verif Crusher
			local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("reticleover",i)		
			if(zo_strformat(SI_ABILITY_NAME,GetAbilityName(abilityId)) == zo_strformat(SI_ABILITY_NAME, GetAbilityName(17906))) then
                DebuffMe.Crusher = timeEnding - currentTimeStamp
			end
        end
        for i=1,GetNumBuffs("reticleover") do --Verif Alkosh
			local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("reticleover",i)		
			if(zo_strformat(SI_ABILITY_NAME,GetAbilityName(abilityId)) == zo_strformat(SI_ABILITY_NAME, GetAbilityName(75753))) then
                DebuffMe.Alkosh = timeEnding - currentTimeStamp
			end
        end
        for i=1,GetNumBuffs("reticleover") do --Verif Taunt
			local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("reticleover",i)		
			if(zo_strformat(SI_ABILITY_NAME,GetAbilityName(abilityId)) == zo_strformat(SI_ABILITY_NAME, GetAbilityName(38541))) then
                DebuffMe.Taunt = timeEnding - currentTimeStamp
			end
        end

        --Convert to text
        local CrusherTXT = ""
        local EngFlamesTXT = ""
        local AlkoshTXT = ""
        local TauntTXT = ""

        if (DebuffMe.Crusher <= 0) then 
            CrusherTXT = "CR" 
        else
            CrusherTXT = tostring(string.format("%.1f", DebuffMe.Crusher))
        end

        if (DebuffMe.EngFlames <= 0) then 
            EngFlamesTXT = "EF" 
        else
            EngFlamesTXT = tostring(string.format("%.1f", DebuffMe.EngFlames))
        end

        if (DebuffMe.Alkosh <= 0) then 
            AlkoshTXT = "AL" 
        else
            AlkoshTXT = tostring(string.format("%.1f", DebuffMe.Alkosh))
        end

        if (DebuffMe.Taunt <= 0) then 
            TauntTXT = "TAUNT" 
        else
            TauntTXT = tostring(string.format("%.1f", DebuffMe.Taunt))
        end
        
        --goto xml
        DebuffMeAlertCrusher:SetText(CrusherTXT)
        DebuffMeAlertEngFlames:SetText(EngFlamesTXT)
        DebuffMeAlertAlkosh:SetText(AlkoshTXT)
        DebuffMeAlertTaunt:SetText(TauntTXT)
        
        --affichage
        local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("reticleover", POWERTYPE_HEALTH)
        if currentTargetHP > 0 then
            DebuffMeAlertCrusher:SetHidden(false)
            DebuffMeAlertEngFlames:SetHidden(false)
            DebuffMeAlertAlkosh:SetHidden(false)
            DebuffMeAlertTaunt:SetHidden(false)
        else 
            DebuffMeAlertCrusher:SetHidden(true)
            DebuffMeAlertEngFlames:SetHidden(true)
            DebuffMeAlertAlkosh:SetHidden(true)
            DebuffMeAlertTaunt:SetHidden(true)
        end
    end
end

function DebuffMe:Initialize()
	--Settings
	--DebuffMe.CreateSettingsWindow()

	--Saved Variables
	DebuffMe.savedVariables = ZO_SavedVars:New("DebuffMeVariables", 1, nil, DebuffMe.Default)
	EVENT_MANAGER:UnregisterForEvent(DebuffMe.name, EVENT_ADD_ON_LOADED)
	--UI
	DebuffMeAlert:SetHidden(false)
	DebuffMeAlert:ClearAnchors()
    DebuffMeAlert:SetAnchor(CENTER, GuiRoot, CENTER, DebuffMe.savedVariables.OffsetX, DebuffMe.savedVariables.OffsetY)
    
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