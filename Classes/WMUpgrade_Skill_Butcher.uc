class WMUpgrade_Skill_Butcher extends WMUpgrade_Skill;

var array<float> MeleeSpeed, RateOfFire;

static simulated function ModifyMeleeAttackSpeedPassive(out float durationFactor, int upgLevel)
{
	durationFactor = 1.0f / (1.0f / durationFactor + default.MeleeSpeed[upgLevel - 1]);
}

static simulated function ModifyRateOfFirePassive(out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.0f / (1.0f / rateOfFireFactor + default.RateOfFire[upgLevel - 1]);
}

defaultproperties
{
	MeleeSpeed(0)=0.15f
	MeleeSpeed(1)=0.4f
	RateOfFire(0)=0.15f
	RateOfFire(1)=0.4f

	UpgradeName="Butcher"
	UpgradeDescription(0)="Attack and shoot 15% faster with <font color=\"#eaeff7\">all weapons</font>"
	UpgradeDescription(1)="Attack and shoot <font color=\"#b346ea\">40%</font> faster with <font color=\"#eaeff7\">all weapons</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Butcher'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Butcher_Deluxe'

	Name="Default__WMUpgrade_Skill_Butcher"
}
