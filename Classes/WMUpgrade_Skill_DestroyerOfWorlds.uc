Class WMUpgrade_Skill_DestroyerOfWorlds extends WMUpgrade_Skill;

var array<float> Damage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != none && (class<KFDT_Explosive>(DamageType) != none || isGrenadeDT(DamageType)))
		InDamage += DefaultDamage * default.Damage[upgLevel-1];
}

static function bool isGrenadeDT( class<KFDamageType> DamageType )
{
	if ( class< KFDT_Explosive_DynamiteGrenade >(DamageType) != none)
		return true;
	if ( class< KFDT_Explosive_FlashBangGrenade >(DamageType) != none)
		return true;
	if ( class< KFDT_EMP_EMPGrenade >(DamageType) != none)
		return true;
	if ( class< KFDT_Explosive_FragGrenade >(DamageType) != none)
		return true;
	if ( class< KFDT_Explosive_HEGrenade >(DamageType) != none)
		return true;
	if ( class< KFDT_Healing_MedicGrenade >(DamageType) != none)
		return true;
	if ( class< KFDT_Fire_MolotovGrenade >(DamageType) != none)
		return true;
	if ( class< KFDT_Freeze_FreezeGrenade >(DamageType) != none)
		return true;
	if ( class< KFDT_Explosive_NailBombGrenade >(DamageType) != none)
		return true;
	return false;
}

defaultproperties
{
	upgradeName="Destroyer Of Worlds"
	upgradeDescription(0)="Increase damage with <font color=\"#eaeff7\">all explosives</font> and <font color=\"#eaeff7\">all grenades</font> 20%"
	upgradeDescription(1)="Increase damage with <font color=\"#eaeff7\">all explosives</font> and <font color=\"#eaeff7\">all grenades</font> <font color=\"#b346ea\">50%</font>"
	Damage(0)=0.200000
	Damage(1)=0.500000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_DestroyerOfWorlds'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_DestroyerOfWorlds_Deluxe'
}