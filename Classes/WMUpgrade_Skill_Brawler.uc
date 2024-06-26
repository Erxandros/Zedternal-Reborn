class WMUpgrade_Skill_Brawler extends WMUpgrade_Skill;

var array<float> Damage;

static function bool CanNotBeGrabbed(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (DamageType != None && (ClassIsChildOf(DamageType, class'KFDT_Bludgeon') || ClassIsChildOf(DamageType, class'KFDT_Piercing') || ClassIsChildOf(DamageType, class'KFDT_Slashing')))
		InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

defaultproperties
{
	Damage(0)=0.05f
	Damage(1)=0.1f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Brawler"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Brawler'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Brawler_Deluxe'

	Name="Default__WMUpgrade_Skill_Brawler"
}
