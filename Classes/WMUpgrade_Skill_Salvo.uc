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

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Salvo"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Salvo'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Salvo_Deluxe'

	Name="Default__WMUpgrade_Skill_Salvo"
}
