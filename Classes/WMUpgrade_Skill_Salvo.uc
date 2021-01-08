class WMUpgrade_Skill_Salvo extends WMUpgrade_Skill;

var array<float> Damage, FireRate;

static function ModifyDamageGivenPassive(out float damageFactor, int upgLevel)
{
	damageFactor += default.Damage[upgLevel - 1];
}

static simulated function ModifyRateOfFirePassive(out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.0f / (1.0f / rateOfFireFactor + default.FireRate[upgLevel - 1]);
}

defaultproperties
{
	Damage(0)=0.1f
	Damage(1)=0.25f
	FireRate(0)=0.1f
	FireRate(1)=0.25f

	upgradeName="Salvo"
	upgradeDescription(0)="Increase damage and rate of fire with <font color=\"#eaeff7\">all weapons</font> by 10%"
	upgradeDescription(1)="Increase damage and rate of fire with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">25%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Salvo'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Salvo_Deluxe'

	Name="Default__WMUpgrade_Skill_Salvo"
}
