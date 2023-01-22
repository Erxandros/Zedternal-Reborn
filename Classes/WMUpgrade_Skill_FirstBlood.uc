class WMUpgrade_Skill_FirstBlood extends WMUpgrade_Skill;

var array<float> DamageDelta, DamageMax;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_FirstBlood_Helper UPG;

	if (ClassIsChildOf(DamageType, class'KFDT_Ballistic') && DamageInstigator != None && DamageInstigator.Pawn != None)
	{
		UPG = GetHelper(KFPawn(DamageInstigator.Pawn));
		if (UPG != None && UPG.bActive)
		{
			InDamage += DefaultDamage * FMin(default.DamageMax[upgLevel - 1], default.DamageDelta[upgLevel - 1] * MyKFW.MagazineCapacity[0]);
			UPG.StartFirstBloodTimer();
		}
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_FirstBlood_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_FirstBlood_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_FirstBlood_Helper', OwnerPawn);
	}
}

static simulated function GetReloadRateScale(out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_FirstBlood_Helper UPG;

	if (OwnerPawn != None && OwnerPawn.Role == Role_Authority)
	{
		UPG = GetHelper(OwnerPawn);
		if (UPG != None)
			UPG.EnableFirstBloodFlag();
	}
}

static function WMUpgrade_Skill_FirstBlood_Helper GetHelper(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_FirstBlood_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_FirstBlood_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_FirstBlood_Helper', OwnerPawn);
	}

	return UPG;
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_FirstBlood_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_FirstBlood_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	DamageDelta(0)=0.05f
	DamageDelta(1)=0.1f
	DamageMax(0)=2.0f
	DamageMax(1)=5.0f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_FirstBlood"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FirstBlood'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FirstBlood_Deluxe'

	Name="Default__WMUpgrade_Skill_FirstBlood"
}
