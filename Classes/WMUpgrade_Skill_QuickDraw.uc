Class WMUpgrade_Skill_QuickDraw extends WMUpgrade_Skill;

var array<float> SwitchSpeed;

static simulated function ModifyWeaponSwitchTimePassive(out float switchTimeFactor, int upgLevel)
{
	switchTimeFactor = 1.0f / (1.0f / switchTimeFactor + default.SwitchSpeed[upgLevel - 1]);
}

defaultproperties
{
	SwitchSpeed(0)=1.0f
	SwitchSpeed(1)=2.5f

	upgradeName="Quick Draw"
	upgradeDescription(0)="Switch <font color=\"#eaeff7\">any weapon</font> 100% faster"
	upgradeDescription(1)="Switch <font color=\"#eaeff7\">any weapon</font> <font color=\"#b346ea\">250%</font> faster"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_QuickDraw'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_QuickDraw_Deluxe'

	Name="Default__WMUpgrade_Skill_QuickDraw"
}
