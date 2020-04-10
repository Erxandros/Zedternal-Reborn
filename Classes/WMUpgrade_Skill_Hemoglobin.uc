Class WMUpgrade_Skill_Hemoglobin extends WMUpgrade_Skill;
	
var Vector VectZero;
var array<int> Damage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != none && class<KFDT_Toxic>(DamageType) != None && DamageInstigator != none && MyKFPM != none && !MyKFPM.bIsPoisoned)
	{
		//add poison effects on zed
		MyKFPM.TakeDamage(default.Damage[upgLevel-1], DamageInstigator, MyKFPM.Location, default.VectZero, Class'ZedternalReborn.WMDT_Hemogoblin');
	}
}


defaultproperties
{
	upgradeName="Hemoglobine"
	upgradeDescription(0)="<font color=\"#caab05\">Poison</font> damages debuff ZEDs"
	upgradeDescription(1)="<font color=\"#caab05\">Poison</font> damages <font color=\"#b346ea\">heavy</font> debuff ZEDs"
	VectZero=(x=0.000000,y=0.000000,z=0.0000000)
	Damage(0)=10
	Damage(1)=50
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Hemoglobin'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Hemoglobin_Deluxe'
}