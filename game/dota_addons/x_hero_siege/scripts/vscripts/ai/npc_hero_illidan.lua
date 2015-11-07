
require('libraries/timers')

function Spawn( entityKeyValues )
	Ability_negative_energy = thisEntity:FindAbilityByName("illidan_bad_negative_energy")
	Ability_immolation = thisEntity:FindAbilityByName("illidan_bad_immolation")
	Ability_metamorphosis = thisEntity:FindAbilityByName("illidan_bad_metamorphosis")

	Timers:CreateTimer(0,IllidanThink)
	DebugPrint("Starting AI for "..thisEntity:GetUnitName().." "..thisEntity:GetEntityIndex())

end

function IllidanThink()
	-- body
	if thisEntity:IsNull() or not thisEntity:IsAlive() then
		return nil
	elseif Ability_negative_energy:IsFullyCastable() then
		--FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		if units ~= nil then
			thisEntity:CastAbilityOnTarget(units[1],Ability_negative_energy,-1)
		end
	elseif Ability_immolation:IsFullyCastable() and not Ability_immolation:GetToggleState() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, Ability_immolation:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
		if units ~= nil then
			thisEntity:CastAbilityToggle(Ability_immolation,-1)
		end

	elseif Ability_metamorphosis:IsFullyCastable() and thisEntity:GetHealthPercent() <= 70 then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
		if units ~= nil then
			thisEntity:CastAbilityNoTarget(Ability_metamorphosis,-1)
		end
	end
	return 2
end