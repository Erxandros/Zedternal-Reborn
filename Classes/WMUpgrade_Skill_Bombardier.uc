Class WMUpgrade_Skill_Bombardier extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != None && isGrenadeDT(DamageType))
		InDamage += DefaultDamage * default.Damage[upgLevel - 1];
}

static function bool isGrenadeDT(class<KFDamageType> DamageType)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Explosive_DynamiteGrenade') || ClassIsChildOf(DamageType, class'KFDT_Explosive_FlashBangGrenade') ||
		ClassIsChildOf(DamageType, class'KFDT_EMP_EMPGrenade') || ClassIsChildOf(DamageType, class'KFDT_Explosive_FragGrenade') ||
		ClassIsChildOf(DamageType, class'KFDT_Explosive_HEGrenade') || ClassIsChildOf(DamageType, class'KFDT_Healing_MedicGrenade') ||
		ClassIsChildOf(DamageType, class'KFDT_Fire_MolotovGrenade') || ClassIsChildOf(DamageType, class'KFDT_Freeze_FreezeGrenade') ||
		ClassIsChildOf(DamageType, class'KFDT_Explosive_NailBombGrenade'))
	{
		return True;
	}

	return False;
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Bombardier_Regen UPG;
	local bool bFound;

	bFound = False;
	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Bombardier_Regen', UPG)
		{
			if (UPG != None)
			{
				bFound = True;
				break;
			}
		}

		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Bombardier_Regen', OwnerPawn);
			UPG.bDeluxe = (upgLevel > 1);
		}
	}
}

defaultproperties
{
	Damage(0)=0.2f
	Damage(1)=0.5f

	upgradeName="Bombardier"
	upgradeDescription(0)="You gain a grenade every 45 seconds. Also increase damage with <font color=\"#eaeff7\">all grenades</font> by 20%"
	upgradeDescription(1)="You gain a grenade every <font color=\"#b346ea\">20</font> seconds. Also increase damage with <font color=\"#eaeff7\">all grenades</font> by <font color=\"#b346ea\">50%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Bombardier'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Bombardier_Deluxe'

	Name="Default__WMUpgrade_Skill_Bombardier"
}
