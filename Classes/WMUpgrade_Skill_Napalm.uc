class WMUpgrade_Skill_Napalm extends WMUpgrade_Skill;

var const class<KFDamageType> WMDT;

var float MaxProbability;
var float MaxDamage;
var array<float> DamageFactor;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != None && DamageType != default.WMDT && DamageInstigator != None && MyKFPM != None && FRand() < (float(DefaultDamage) * default.MaxProbability / default.MaxDamage))
	{
		//add fire/microwave effects on zed
		MyKFPM.ApplyDamageOverTime(int(float(DefaultDamage) * default.DamageFactor[upgLevel - 1]), DamageInstigator, default.WMDT);
	}
}

static simulated function bool CanSpreadNapalm(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	WMDT=class'ZedternalReborn.WMDT_Napalm'
	MaxProbability=1.0f
	MaxDamage=75.0f
	DamageFactor(0)=0.2f
	DamageFactor(1)=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Napalm"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Napalm'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Napalm_Deluxe'

	Name="Default__WMUpgrade_Skill_Napalm"
}
