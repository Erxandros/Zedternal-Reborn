Class WMUpgrade_Skill_HeavyArmor extends WMUpgrade_Skill;

var array<float> Armor;

static function ModifyArmor( out byte MaxArmor, byte DefaultArmor, int upgLevel)
{
	MaxArmor = min(255, MaxArmor + Round(float(DefaultArmor) * default.Armor[upgLevel-1]));
}

defaultproperties
{
	upgradeName="Heavy Armor"
	upgradeDescription(0)="Increase max armor 30%"
	upgradeDescription(1)="Increase max armor <font color=\"#b346ea\">75%</font>"
	Armor(0)=0.300000
	Armor(1)=0.750000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_HeavyArmor'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_HeavyArmor_Deluxe'
}