class WMUpgrade_Skill_Combustion extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != None && (ClassIsChildOf(DamageType, class'KFDT_Fire') || ClassIsChildOf(DamageType, class'KFDT_Toxic') || ClassIsChildOf(DamageType, class'KFDT_Freeze')))
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1] * upgLevel);
}

defaultproperties
{
	Damage(0)=0.25f
	Damage(1)=0.60f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Combustion"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Combustion'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Combustion_Deluxe'

	Name="Default__WMUpgrade_Skill_Combustion"
}
