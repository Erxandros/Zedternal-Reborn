Class WMUpgrade_Skill_Salvo extends WMUpgrade_Skill;
	
var array<float> Damage, fireRate;

static function ModifyDamageGivenPassive( out float damageFactor, int upgLevel)
{
	damageFactor += default.Damage[upgLevel-1];
}

static simulated function ModifyRateOfFirePassive( out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.f / (1.f/rateOfFireFactor + default.fireRate[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Salvo"
	upgradeDescription(0)="Increase damage and rate of fire with <font color=\"#eaeff7\">all weapons</font> 10%"
	upgradeDescription(1)="Increase damage and rate of fire with <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">25%</font>"
	Damage(0)=0.100000;
	Damage(1)=0.250000;
	fireRate(0)=0.100000;
	fireRate(1)=0.250000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Salvo'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Salvo_Deluxe'
}