class WMUpgrade_Skill_AcidicRounds extends WMUpgrade_Skill;

var const class<KFDamageType> WMDT;

var float maxProbability;
var float maxDamage;
var array<float> damageFactor;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != None && DamageType != default.WMDT && DamageInstigator != None && MyKFPM != None && !MyKFPM.bIsPoisoned && FRand() < (float(DefaultDamage) * default.maxProbability / default.maxDamage))
	{
		//add poison effects on zed
		MyKFPM.ApplyDamageOverTime(int(float(DefaultDamage) * default.damageFactor[upgLevel - 1]), DamageInstigator, default.WMDT);
	}
}

defaultproperties
{
	WMDT=class'ZedternalReborn.WMDT_AcidicRounds_DoT'
	maxProbability=1.0f
	maxDamage=75.0f
	damageFactor(0)=0.2f
	damageFactor(1)=0.5f

	upgradeName="Acidic Rounds"
	upgradeDescription(0)="<font color=\"#eaeff7\">All weapons</font> can poison ZEDs, inflicting poison damage over time"
	upgradeDescription(1)="<font color=\"#eaeff7\">All weapons</font> can poison ZEDs, inflicting <font color=\"#b346ea\">high</font> poison damage over time"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AcidicRounds'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AcidicRounds_Deluxe'

	Name="Default__WMUpgrade_Skill_AcidicRounds"
}
