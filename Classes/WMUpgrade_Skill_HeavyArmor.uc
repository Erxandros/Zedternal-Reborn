class WMUpgrade_Skill_HeavyArmor extends WMUpgrade_Skill;

var array<float> Armor;

static function ModifyArmor(out int MaxArmor, int DefaultArmor, int upgLevel)
{
	MaxArmor += Round(float(DefaultArmor) * default.Armor[upgLevel - 1]);
}

defaultproperties
{
	Armor(0)=0.3f
	Armor(1)=0.75f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_HeavyArmor"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HeavyArmor'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HeavyArmor_Deluxe'

	Name="Default__WMUpgrade_Skill_HeavyArmor"
}
