class WMUpgrade_Skill_BringTheHeat extends WMUpgrade_Skill;

var float FireBonus;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_BringTheHeat_Helper UPG;

	if (DamageType != None && DamageInstigator.Pawn != None)
	{
		UPG = GetHelper(DamageInstigator.Pawn);
		if (UPG != None)
		{
			if (ClassIsChildOf(DamageType, class'KFDT_Fire'))
				UPG.CumulativeDamage += Round(InDamage * default.FireBonus * upgLevel);
			else
				UPG.CumulativeDamage += InDamage * upgLevel;
		}
	}
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'WMDT_BringTheHeat'))
		InDamage = 0;
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_BringTheHeat_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_BringTheHeat_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_BringTheHeat_Helper', OwnerPawn);
	}
}

static function WMUpgrade_Skill_BringTheHeat_Helper GetHelper(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_BringTheHeat_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_BringTheHeat_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_BringTheHeat_Helper', OwnerPawn);
	}

	return UPG;
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_BringTheHeat_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_BringTheHeat_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	FireBonus=1.4f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_BringTheHeat"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_BringTheHeat'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_BringTheHeat_Deluxe'

	Name="Default__WMUpgrade_Skill_BringTheHeat"
}
