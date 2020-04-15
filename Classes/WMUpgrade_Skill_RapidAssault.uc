Class WMUpgrade_Skill_RapidAssault extends WMUpgrade_Skill;

var array<float> rateOfFire;

static simulated function ModifyRateOfFirePassive( out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.f / (1.f/rateOfFireFactor + default.rateOfFire[upgLevel-1]);
}

static simulated function ModifyMeleeAttackSpeedPassive( out float durationFactor, int upgLevel)
{
	durationFactor = 1.f / (1.f/durationFactor + default.rateOfFire[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Rapid Assault"
	upgradeDescription(0)="Attack and shoot 20% faster with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Attack and shoot <font color=\"#b346ea\">50%</font> faster with <font color=\"#eaeff7\">all weapons</font>"
	rateOfFire(0)=0.2000000
	rateOfFire(1)=0.5000000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_RapidAssault'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_RapidAssault_Deluxe'
}