class WMUpgrade_Skill_Ruthless extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGivenPassive(out float damageFactor, int upgLevel)
{
	damageFactor += default.Damage[upgLevel - 1];
}

defaultproperties
{
	Damage(0)=0.15f
	Damage(1)=0.4f

	UpgradeName="Ruthless"
	UpgradeDescription(0)="Increase damage with <font color=\"#eaeff7\">all weapons</font> by 15%"
	UpgradeDescription(1)="Increase damage with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">40%</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Ruthless'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Ruthless_Deluxe'

	Name="Default__WMUpgrade_Skill_Ruthless"
}
