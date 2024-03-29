class WMUpgrade_Skill_RapidAssault extends WMUpgrade_Skill;

var array<float> RateOfFire;

static simulated function ModifyRateOfFirePassive(out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.0f / (1.0f / rateOfFireFactor + default.RateOfFire[upgLevel - 1]);
}

static simulated function ModifyMeleeAttackSpeedPassive(out float durationFactor, int upgLevel)
{
	durationFactor = 1.0f / (1.0f / durationFactor + default.RateOfFire[upgLevel - 1]);
}

defaultproperties
{
	RateOfFire(0)=0.2f
	RateOfFire(1)=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_RapidAssault"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_RapidAssault'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_RapidAssault_Deluxe'

	Name="Default__WMUpgrade_Skill_RapidAssault"
}
