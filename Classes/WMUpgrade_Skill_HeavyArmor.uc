class WMUpgrade_Skill_HeavyArmor extends WMUpgrade_Skill;

var array<float> Armor;

static function ModifyArmor(out byte MaxArmor, byte DefaultArmor, int upgLevel)
{
	MaxArmor = Min(255, MaxArmor + Round(float(DefaultArmor) * default.Armor[upgLevel - 1]));
}

defaultproperties
{
	Armor(0)=0.3f
	Armor(1)=0.75f

	upgradeName="Heavy Armor"
	upgradeDescription(0)="Increase max armor by 30%"
	upgradeDescription(1)="Increase max armor by <font color=\"#b346ea\">75%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HeavyArmor'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HeavyArmor_Deluxe'

	Name="Default__WMUpgrade_Skill_HeavyArmor"
}
