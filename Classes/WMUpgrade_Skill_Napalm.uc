Class WMUpgrade_Skill_Napalm extends WMUpgrade_Skill;
	
var Vector VectZero;
var float maxProbability;
var float maxDamage;
var array<float> damageFactor;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != none && DamageType != Class'ZedternalReborn.WMDT_Napalm' && DamageInstigator != none && MyKFPM != none && FRand() < (float(DefaultDamage) * default.maxProbability / default.maxDamage))
	{
		//add fire/microwave effects on zed
		MyKFPM.ApplyDamageOverTime(int(float(DefaultDamage)*default.damageFactor[upgLevel-1]), DamageInstigator, Class'ZedternalReborn.WMDT_Napalm');
	}
}

static simulated function bool CanSpreadNapalm(int upgLevel, KFPawn OwnerPawn)
{
	return true;
}


defaultproperties
{
	upgradeName="Napalm"
	upgradeDescription(0)="<font color=\"#eaeff7\">All weapons</font> can put ZEDs on fire. Burning ZEDs that make contact with other ZEDs will light them on fire"
	upgradeDescription(1)="<font color=\"#eaeff7\">All weapons</font> can put ZEDs on <font color=\"#b346ea\">heavy</font> fire. Burning ZEDs that make contact with other ZEDs will light them on fire"
	VectZero=(x=0.000000,y=0.000000,z=0.0000000)
	maxProbability=1.000000
	maxDamage=75.000000
	damageFactor(0)=0.200000
	damageFactor(1)=0.500000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Napalm'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Napalm_Deluxe'
}