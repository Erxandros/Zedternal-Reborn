class WMUpgrade_Skill_Marksman extends WMUpgrade_Skill;

var array<float> RateOfFire, Speed;

static simulated function ModifyRateOfFirePassive(out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.0f / (1.0f / rateOfFireFactor + default.RateOfFire[upgLevel - 1]);
}

static simulated function ModifyMeleeAttackSpeedPassive(out float durationFactor, int upgLevel)
{
	durationFactor = 1.0f / (1.0f / durationFactor + default.RateOfFire[upgLevel - 1]);
}

static simulated function ModifySpeedPassive(out float speedFactor, int upgLevel)
{
	speedFactor += default.Speed[upgLevel - 1];
}

defaultproperties
{
	RateOfFire(0)=0.15f
	RateOfFire(1)=0.4f
	Speed(0)=0.05f
	Speed(1)=0.1f

	UpgradeName="Marksman"
	UpgradeDescription(0)="Attack and shoot 15% faster with <font color=\"#eaeff7\">all weapons</font> and move 5% faster"
	UpgradeDescription(1)="Attack and shoot <font color=\"#b346ea\">40%</font> faster with <font color=\"#eaeff7\">all weapons</font> and move <font color=\"#b346ea\">10%</font> faster"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Marksman'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Marksman_Deluxe'

	Name="Default__WMUpgrade_Skill_Marksman"
}
