class WMUpgrade_Skill_Strength extends WMUpgrade_Skill;

var array<int> Bonus;

static function ApplyWeightLimits(out int InWeightLimit, int DefaultWeightLimit, int upgLevel)
{
	InWeightLimit += default.Bonus[upgLevel - 1];
}

defaultproperties
{
	Bonus(0)=3
	Bonus(1)=8

	UpgradeName="Strength"
	UpgradeDescription(0)="Increase weight capacity by 3"
	UpgradeDescription(1)="Increase weight capacity by <font color=\"#b346ea\">8</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Strength'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Strength_Deluxe'

	Name="Default__WMUpgrade_Skill_Strength"
}
