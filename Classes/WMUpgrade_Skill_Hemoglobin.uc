class WMUpgrade_Skill_Hemoglobin extends WMUpgrade_Skill;

var const class<KFDamageType> WMDT;

var Vector VectZero;
var array<int> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Toxic') && DamageInstigator != None && MyKFPM != None && !MyKFPM.bIsPoisoned)
	{
		//add poison effects on zed
		MyKFPM.TakeDamage(default.Damage[upgLevel - 1], DamageInstigator, MyKFPM.Location, default.VectZero, default.WMDT);
	}
}

defaultproperties
{
	WMDT=class'ZedternalReborn.WMDT_Hemogoblin'
	VectZero=(x=0.0f,y=0.0f,z=0.0f)
	Damage(0)=10
	Damage(1)=50

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Hemoglobin"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Hemoglobin'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Hemoglobin_Deluxe'

	Name="Default__WMUpgrade_Skill_Hemoglobin"
}
