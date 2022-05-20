class WMUpgrade_Skill_RiotShield extends WMUpgrade_Skill;

var array<float> Damage, OtherDamage;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(Damagetype, class'KFDT_Ballistic'))
		InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
	else
		InDamage -= Round(float(DefaultDamage) * default.OtherDamage[upgLevel - 1]);
}

defaultproperties
{
	Damage(0)=0.5f
	Damage(1)=0.9f
	OtherDamage(0)=0.05f
	OtherDamage(1)=0.1f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_RiotShield"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_RiotShield'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_RiotShield_Deluxe'

	Name="Default__WMUpgrade_Skill_RiotShield"
}
