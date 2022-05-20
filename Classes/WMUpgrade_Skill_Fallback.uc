class WMUpgrade_Skill_Fallback extends WMUpgrade_Skill;

var array<float> Damage;
var array<int> ExtraGrenades;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFW != None && (MyKFW.default.bIsBackupWeapon || MyKFW.Class.Name == 'KFWeap_Pistol_Dual9mm'))
		InDamage += DefaultDamage * default.Damage[upgLevel - 1];
}

static simulated function ModifySpareGrenadeAmount(out int SpareGrenade, int DefaultSpareGrenade, int upgLevel)
{
	SpareGrenade += default.ExtraGrenades[upgLevel - 1];
}

defaultproperties
{
	Damage(0)=1.0f
	Damage(1)=2.5f
	ExtraGrenades(0)=1
	ExtraGrenades(1)=2

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Fallback"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Fallback'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Fallback_Deluxe'

	Name="Default__WMUpgrade_Skill_Fallback"
}
