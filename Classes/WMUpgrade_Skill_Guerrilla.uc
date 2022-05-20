class WMUpgrade_Skill_Guerrilla extends WMUpgrade_Skill;

var array<float> Bonus;

static function ModifyDamageGivenPassive(out float damageFactor, int upgLevel)
{
	damageFactor += default.Bonus[upgLevel - 1];
}

static function ModifyHealth(out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += Round(float(DefaultHealth) * default.Bonus[upgLevel - 1]);
}

defaultproperties
{
	Bonus(0)=0.1f
	Bonus(1)=0.25f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Guerrilla"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Guerrilla'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Guerrilla_Deluxe'

	Name="Default__WMUpgrade_Skill_Guerrilla"
}
