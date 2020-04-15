Class WMUpgrade_Skill_Strength extends WMUpgrade_Skill;
	
var array<int> Bonus;
	
static function ApplyWeightLimits(out int InWeightLimit, int DefaultWeightLimit, int upgLevel)
{
	InWeightLimit += default.Bonus[upgLevel-1];
}
	
defaultproperties
{
	upgradeName="Strength"
	upgradeDescription(0)="Increase weight capacity by 3"
	upgradeDescription(1)="Increase weight capacity by <font color=\"#b346ea\">8</font>"
	Bonus(0)=3
	Bonus(1)=8
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Strength'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Strength_Deluxe'
}