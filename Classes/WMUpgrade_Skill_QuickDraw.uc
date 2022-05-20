class WMUpgrade_Skill_QuickDraw extends WMUpgrade_Skill;

var array<float> SwitchSpeed;

static simulated function ModifyWeaponSwitchTimePassive(out float switchTimeFactor, int upgLevel)
{
	switchTimeFactor = 1.0f / (1.0f / switchTimeFactor + default.SwitchSpeed[upgLevel - 1]);
}

defaultproperties
{
	SwitchSpeed(0)=1.0f
	SwitchSpeed(1)=2.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_QuickDraw"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_QuickDraw'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_QuickDraw_Deluxe'

	Name="Default__WMUpgrade_Skill_QuickDraw"
}
