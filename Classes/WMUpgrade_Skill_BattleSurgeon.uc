Class WMUpgrade_Skill_BattleSurgeon extends WMUpgrade_Skill;
	
var array<float> Damage, Otherdamage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk( MyKFW, class'KFGame.KFPerk_FieldMedic') || IsDamageTypeOnSpecificPerk( DamageType, class'KFGame.KFPerk_FieldMedic'))
		InDamage += DefaultDamage * default.Damage[upgLevel-1];
	else
		InDamage += DefaultDamage * default.Otherdamage[upgLevel-1];
}

defaultproperties
{
	upgradeName="Battle Surgeon"
	upgradeDescription(0)="Increase damage with <font color=\"#caab05\">FieldMedic's weapons</font> 20% and with <font color=\"#eaeff7\">other weapons</font> 10%"
	upgradeDescription(1)="Increase damage with <font color=\"#caab05\">FieldMedic's weapons</font> <font color=\"#b346ea\">50%</font> and with <font color=\"#eaeff7\">other weapons</font> <font color=\"#b346ea\">25%</font>"
	Damage(0)=0.200000;
	Damage(1)=0.500000;
	Otherdamage(0)=0.100000;
	Otherdamage(1)=0.250000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_BattleSurgeon'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_BattleSurgeon_Deluxe'
}