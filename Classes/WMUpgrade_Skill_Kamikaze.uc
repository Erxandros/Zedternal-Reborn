class WMUpgrade_Skill_Kamikaze extends WMUpgrade_Skill;

var float DamageDeluxe;

static simulated function bool ShouldSacrifice(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

static function ModifyDamageGivenPassive(out float damageFactor, int upgLevel)
{
	if (upgLevel > 1)
		damageFactor += default.DamageDeluxe;
}

defaultproperties
{
	DamageDeluxe=0.25f

	upgradeName="Kamikaze"
	upgradeDescription(0)="Once per wave, explode and survive when your health reaches critical level"
	upgradeDescription(1)="Once per wave, explode and survive when your health reaches critical level. Increase damage with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">25%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Kamikaze'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Kamikaze_Deluxe'

	Name="Default__WMUpgrade_Skill_Kamikaze"
}
