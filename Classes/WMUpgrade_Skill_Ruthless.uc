Class WMUpgrade_Skill_Ruthless extends WMUpgrade_Skill;
	
var array<float> Damage;

static function ModifyDamageGivenPassive( out float damageFactor, int upgLevel)
{
	damageFactor += default.Damage[upgLevel-1];
}


defaultproperties
{
	upgradeName="Ruthless"
	upgradeDescription(0)="Increase damage with <font color=\"#eaeff7\">all weapons</font> 15%"
	upgradeDescription(1)="Increase damage with <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">40%</font>"
	Damage(0)=0.150000;
	Damage(1)=0.400000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Ruthless'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Ruthless_Deluxe'
}