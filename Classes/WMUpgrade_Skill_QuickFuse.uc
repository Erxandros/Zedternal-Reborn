class WMUpgrade_Skill_QuickFuse extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != None && static.IsGrenadeDT(DamageType))
		InDamage += DefaultDamage * default.Damage[upgLevel - 1];
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local KFPlayerController KFPC;
	local KFPerk currentPerk;

	if (OwnerPawn != None)
	{
		KFPC = KFPlayerController(OwnerPawn.Controller);
		if (KFPC != None)
		{
			currentPerk = WMPerk(KFPC.CurrentPerk);
			if (currentPerk != None)
				UpdateGrenade(currentPerk);
		}
	}
}

static simulated function ModifyWeaponSwitchTime(out float InSwitchTime, float DefaultSwitchTime, int upgLevel, KFWeapon KFW)
{
	local KFPlayerController KFPC;
	local KFPerk currentPerk;

	KFPC = KFPlayerController(Pawn(KFW.Owner).Controller);
	if (KFPC != None)
	{
		currentPerk = WMPerk(KFPC.CurrentPerk);
		if (currentPerk != None)
			UpdateGrenade(currentPerk);
	}
}

static simulated function UpdateGrenade(KFPerk currentPerk)
{
	if (currentPerk != None)
	{
		switch(currentPerk.GrenadeClass)
		{
			case class'KFProj_FlashBangGrenade':
				currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_FlashBangGrenade_QuickFuse'; break;
			case class'KFProj_FragGrenade':
				currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_FragGrenade_QuickFuse'; break;
			case class'KFProj_EMPGrenade':
				currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_EMPGrenade_QuickFuse'; break;
			case class'KFProj_HEGrenade':
				currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_HEGrenade_QuickFuse'; break;
			case class'WMProj_MedicGrenade':
				currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_MedicGrenade_QuickFuse'; break;
			case class'KFProj_NailBombGrenade':
				currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_NailBombGrenade_QuickFuse'; break;
			case class'KFProj_FreezeGrenade':
				currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_FreezeGrenade_QuickFuse'; break;
			case class'KFProj_DynamiteGrenade':
				currentPerk.GrenadeClass = class'ZedternalReborn.WMProj_DynamiteGrenade_QuickFuse'; break;
		}
	}
}

static simulated function RevertUpgradeChanges(Pawn OwnerPawn)
{
	local KFPlayerController KFPC;
	local KFPerk CurrentPerk;

	KFPC = KFPlayerController(OwnerPawn.Controller);

	if (KFPC != None)
	{
		CurrentPerk = WMPerk(KFPC.CurrentPerk);
		if (CurrentPerk != None)
		{
			switch(CurrentPerk.GrenadeClass)
			{
				case class'ZedternalReborn.WMProj_FlashBangGrenade_QuickFuse':
					currentPerk.GrenadeClass = class'KFProj_FlashBangGrenade'; break;
				case class'ZedternalReborn.WMProj_FragGrenade_QuickFuse':
					currentPerk.GrenadeClass = class'KFProj_FragGrenade'; break;
				case class'ZedternalReborn.WMProj_EMPGrenade_QuickFuse':
					currentPerk.GrenadeClass = class'KFProj_EMPGrenade'; break;
				case class'ZedternalReborn.WMProj_HEGrenade_QuickFuse':
					currentPerk.GrenadeClass = class'KFProj_HEGrenade'; break;
				case class'ZedternalReborn.WMProj_MedicGrenade_QuickFuse':
					currentPerk.GrenadeClass = class'WMProj_MedicGrenade'; break;
				case class'ZedternalReborn.WMProj_NailBombGrenade_QuickFuse':
					currentPerk.GrenadeClass = class'KFProj_NailBombGrenade'; break;
				case class'ZedternalReborn.WMProj_FreezeGrenade_QuickFuse':
					currentPerk.GrenadeClass = class'KFProj_FreezeGrenade'; break;
				case class'ZedternalReborn.WMProj_DynamiteGrenade_QuickFuse':
					currentPerk.GrenadeClass = class'KFProj_DynamiteGrenade'; break;
			}
		}
	}
}

defaultproperties
{
	Damage(0)=0.2f
	Damage(1)=0.5f

	upgradeName="Quick Fuse"
	upgradeDescription(0)="Decrease fuse time of <font color=\"#eaeff7\">all grenades</font> by 50% and increase damage with <font color=\"#eaeff7\">all grenades</font> by 20%"
	upgradeDescription(1)="Decrease fuse time of <font color=\"#eaeff7\">all grenades</font> by 50% and increase damage with <font color=\"#eaeff7\">all grenades</font> by <font color=\"#b346ea\">50%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_QuickFuse'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_QuickFuse_Deluxe'

	Name="Default__WMUpgrade_Skill_QuickFuse"
}
