Class WMUpgrade_Skill_Massacre extends WMUpgrade_Skill;
	
var array<float> meleeDamage, damage;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != None && static.IsMeleeDamageType(DamageType))
		InDamage += int(float(DefaultDamage) * default.meleeDamage[upgLevel-1]);
	else
		InDamage += int(float(DefaultDamage) * default.damage[upgLevel-1]);
}


defaultproperties
{
	upgradeName="Massacre"
	upgradeDescription(0)="Increase damage with <font color=\"#caab05\">melee weapons</font> 20% . Increase damage with <font color=\"#eaeff7\">other weapons</font> 5%"
	upgradeDescription(1)="Increase damage with <font color=\"#caab05\">melee weapons</font> <font color=\"#b346ea\">50%</font>. Increase damage with <font color=\"#eaeff7\">other weapons</font> <font color=\"#b346ea\">15%</font>"
	damage(0)=0.050000;
	damage(1)=0.150000;
	meleeDamage(0)=0.200000;
	meleeDamage(1)=0.500000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Massacre'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Massacre_Deluxe'
}