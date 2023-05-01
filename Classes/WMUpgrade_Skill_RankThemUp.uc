class WMUpgrade_Skill_RankThemUp extends WMUpgrade_Skill;

var array<float> ExtraDamage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_RankThemUp_Helper UPG;

	if (DamageType != None && MyKFPM != None && DamageInstigator != None && DamageInstigator.Pawn != None && MyKFPM.IsAliveAndWell() && !MyKFPM.bCheckingExtraHeadDamage && HitZoneIdx == HZI_HEAD)
	{
		UPG = GetHelper(DamageInstigator.Pawn);
		if (UPG != None)
		{
			if (UPG.HeadShot < UPG.MaxHeadShot)
				UPG.IncreaseCounter();
			else
			{
				UPG.EndStrike();
				InDamage += Round(float(DefaultDamage) * default.ExtraDamage[upgLevel - 1]);
			}
		}
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_RankThemUp_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_RankThemUp_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_RankThemUp_Helper', OwnerPawn);
	}
}

static function WMUpgrade_Skill_RankThemUp_Helper GetHelper(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_RankThemUp_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_RankThemUp_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_RankThemUp_Helper', OwnerPawn);
	}

	return UPG;
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_RankThemUp_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_RankThemUp_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	ExtraDamage(0)=1.5f
	ExtraDamage(1)=3.75f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_RankThemUp"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_RankThemUp'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_RankThemUp_Deluxe'

	Name="Default__WMUpgrade_Skill_RankThemUp"
}
