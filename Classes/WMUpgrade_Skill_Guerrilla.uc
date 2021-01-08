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

	upgradeName="Guerrilla"
	upgradeDescription(0)="Increase maximum health and damage with <font color=\"#eaeff7\">all weapons</font> by 10%"
	upgradeDescription(1)="Increase maximum health and damage with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">25%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Guerrilla'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Guerrilla_Deluxe'

	Name="Default__WMUpgrade_Skill_Guerrilla"
}
