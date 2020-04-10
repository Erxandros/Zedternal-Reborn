Class WMUpgrade_Skill_QuickFuse extends WMUpgrade_Skill;

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
	local KFPlayerController KFPC;
	local KFPerk currentPerk;
	
	if (OwnerPawn != none)
	{
		KFPC = KFPlayerController(OwnerPawn.Controller);
		if (KFPC != none)
		{
			currentPerk = WMPerk(KFPC.CurrentPerk);
			if (currentPerk != none)
				UpdateGrenade(currentPerk);
		}
	}
}


static simulated function ModifyWeaponSwitchTime(out float InSwitchTime, float DefaultSwitchTime, int upgLevel, KFWeapon KFW)
{
	local KFPlayerController KFPC;
	local KFPerk currentPerk;
	
	KFPC = KFPlayerController(Pawn(KFW.Owner).Controller);
	if (KFPC != none)
	{
		currentPerk = WMPerk(KFPC.CurrentPerk);
		if (currentPerk != none)
			UpdateGrenade(currentPerk);
	}
}

static simulated function UpdateGrenade(KFPerk currentPerk)
{
	if (currentPerk != none)
	{
		switch(currentPerk.GrenadeClass)
		{
			case class'KFProj_FlashBangGrenade'	: currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_FlashBangGrenade_QuickFuse';	break;
			case class'KFProj_FragGrenade' 		: currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_FragGrenade_QuickFuse';			break;
			case class'KFProj_HansHEGrenade'	: currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_HansHEGrenade_QuickFuse';		break;
			case class'KFProj_EMPGrenade'		: currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_EMPGrenade_QuickFuse';			break;
			case class'KFProj_HEGrenade'		: currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_HEGrenade_QuickFuse';			break;
			case class'KFProj_MedicGrenade'		: currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_MedicGrenade_QuickFuse';		break;
			case class'KFProj_NailBombGrenade'	: currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_NailBombGrenade_QuickFuse';		break;
			case class'KFProj_FreezeGrenade'	: currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_FreezeGrenade_QuickFuse';		break;
			case class'KFProj_DynamiteGrenade'	: currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_DynamiteGrenade_QuickFuse';		break;
		}
	}
}

defaultproperties
{
	upgradeName="Quick Fuse"
	upgradeDescription(0)="Decrease fuse time of <font color=\"#eaeff7\">all grenades</font> by 50%. Increase damage with <font color=\"#eaeff7\">all grenades</font> 20%"
	upgradeDescription(1)="Decrease fuse time of <font color=\"#eaeff7\">all grenades</font> by 50%. Increase damage with <font color=\"#eaeff7\">all grenades</font> <font color=\"#b346ea\">50%</font>"
	Damage(0)=0.200000;
	Damage(1)=0.500000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_QuickFuse'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_QuickFuse_Deluxe'
}