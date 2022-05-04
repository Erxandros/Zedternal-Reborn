class WMUpgrade_Skill_Salvo extends WMUpgrade_Skill;

var array<float> Bonus;

static function ModifyDamageGivenPassive(out float damageFactor, int upgLevel)
{
	damageFactor += default.Bonus[upgLevel - 1];
}

static simulated function ModifyRateOfFirePassive(out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.0f / (1.0f / rateOfFireFactor + default.Bonus[upgLevel - 1]);
}

defaultproperties
{
	Bonus(0)=0.1f
	Bonus(1)=0.25f

	UpgradeName="Salvo"
	UpgradeDescription(0)="Increase damage and rate of fire for <font color=\"#eaeff7\">all weapons</font> by 10%"
	UpgradeDescription(1)="Increase damage and rate of fire for <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">25%</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Salvo'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Salvo_Deluxe'

	Name="Default__WMUpgrade_Skill_Salvo"
}
