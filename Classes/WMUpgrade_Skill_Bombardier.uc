Class WMUpgrade_Skill_Bombardier extends WMUpgrade_Skill;
	
var array<float> Damage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != none && isGrenadeDT(DamageType))
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


static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Bombardier_Regen UPG;
	local bool bFound;
	
	bFound = false;
	if (KFPawn_Human(OwnerPawn)!=none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Bombardier_Regen',UPG)
			bFound = true;
		
		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Bombardier_Regen',OwnerPawn);
			UPG.bDeluxe = (upgLevel > 1);
		}
	}
}

defaultproperties
{
	upgradeName="Bombardier"
	upgradeDescription(0)="You gain a grenade every 45 seconds. Also increase damage with <font color=\"#eaeff7\">all grenades</font> 20%"
	upgradeDescription(1)="You gain a grenade every <font color=\"#b346ea\">20</font> seconds. Also increase damage with <font color=\"#eaeff7\">all grenades</font> <font color=\"#b346ea\">50%</font>"
	Damage(0)=0.200000;
	Damage(1)=0.500000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Bombardier'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Bombardier_Deluxe'
}