Class WMUpgrade_Skill_Guerrilla extends WMUpgrade_Skill;
	
var array<float> bonus;

static function ModifyDamageGivenPassive( out float damageFactor, int upgLevel)
{
	damageFactor += default.bonus[upgLevel-1];
}

static function ModifyHealth( out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += Round(float(DefaultHealth) * default.bonus[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Guerrilla"
	upgradeDescription(0)="Increase maximum health and damage with <font color=\"#eaeff7\">all weapons</font> 10%"
	upgradeDescription(1)="Increase maximum health and damage with <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">25%</font>"
	bonus(0)=0.100000;
	bonus(1)=0.250000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Guerrilla'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Guerrilla_Deluxe'
}