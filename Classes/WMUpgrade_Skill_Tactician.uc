class WMUpgrade_Skill_Tactician extends WMUpgrade_Skill;

var array<float> Mod;

static simulated function GetZedTimeModifier(out float InModifier, int upgLevel, KFWeapon KFW)
{
	local name StateName;
	StateName = KFW.GetStateName();

	if (class'ZedternalReborn.WMWeaponStates'.static.IsWeaponReloadState(StateName) || class'ZedternalReborn.WMWeaponStates'.static.IsWeaponSwitchState(StateName))
		InModifier += default.Mod[upgLevel - 1];
}

defaultproperties
{
	Mod(0)=1.0f
	Mod(1)=1.75f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Tactician"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tactician'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tactician_Deluxe'

	Name="Default__WMUpgrade_Skill_Tactician"
}
