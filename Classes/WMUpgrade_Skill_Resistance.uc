class WMUpgrade_Skill_Resistance extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (DamageType != None && (ClassIsChildOf(Damagetype, class'KFDT_Toxic') || ClassIsChildOf(Damagetype, class'KFDT_Sonic') || ClassIsChildOf(Damagetype, class'KFDT_Fire')))
		InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

defaultproperties
{
	Damage(0)=0.25f
	Damage(1)=0.6f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Resistance"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Resistance'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Resistance_Deluxe'

	Name="Default__WMUpgrade_Skill_Resistance"
}
