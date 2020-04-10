Class WMUpgrade_Skill_QuickDraw extends WMUpgrade_Skill;
	
var array<float> switchSpeed;
	
static simulated function ModifyWeaponSwitchTimePassive(out float switchTimeFactor, int upgLevel)
{
	switchTimeFactor = 1.f / (1.f/switchTimeFactor + default.switchSpeed[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Quick Draw"
	upgradeDescription(0)="Switch <font color=\"#eaeff7\">any weapon</font> 100% faster"
	upgradeDescription(1)="Switch <font color=\"#eaeff7\">any weapon</font> <font color=\"#b346ea\">250%</font> faster"
	switchSpeed(0)=1.000000;
	switchSpeed(1)=2.500000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_QuickDraw'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_QuickDraw_Deluxe'
}