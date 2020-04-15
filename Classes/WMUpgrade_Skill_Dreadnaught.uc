Class WMUpgrade_Skill_Dreadnaught extends WMUpgrade_Skill;
	
var array<float> Health;
	
static function ModifyHealth( out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += Round(float(DefaultHealth) * default.Health[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Dreadnaught"
	upgradeDescription(0)="Increase total Health by 25%"
	upgradeDescription(1)="Increase total Health by <font color=\"#b346ea\">60%</font>"
	Health(0)=0.250000;
	Health(1)=0.600000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Dreadnaught'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Dreadnaught_Deluxe'
}