Class WMUpgrade_Skill_Fallback extends WMUpgrade_Skill;
	
var array<float> Damage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if ( MyKFW != none && MyKFW.default.bIsBackupWeapon )
		InDamage += DefaultDamage * default.Damage[upgLevel-1];
}

defaultproperties
{
	upgradeName="Fallback"
	upgradeDescription(0)="Increase damage with your 9mm pistol and your knife 100%"
	upgradeDescription(1)="Increase damage with your 9mm pistol and your knife <font color=\"#b346ea\">250%</font>"
	Damage(0)=1.000000;
	Damage(1)=2.500000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Fallback'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Fallback_Deluxe'
}