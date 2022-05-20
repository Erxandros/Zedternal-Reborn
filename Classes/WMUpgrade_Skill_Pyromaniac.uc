class WMUpgrade_Skill_Pyromaniac extends WMUpgrade_Skill;

var array<float> RateOfFire;

static simulated function bool GetIsUberAmmoActive(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Pyromaniac_Helper UPG;

	UPG = GetHelper(OwnerPawn, upgLevel);
	if (UPG != None && UPG.bEnable)
		return True;
	else
		return False;
}

static simulated function ModifyMeleeAttackSpeed(out float InDuration, float DefaultDuration, int upgLevel, KFWeapon KFW)
{
	local WMUpgrade_Skill_Pyromaniac_Helper UPG;

	UPG = GetHelper(KFPawn(KFW.Owner), upgLevel);
	if (UPG != None && UPG.bEnable)
		InDuration = DefaultDuration / (DefaultDuration / InDuration + default.RateOfFire[upgLevel - 1]);
}

static simulated function ModifyRateOfFire(out float InRate, float DefaultRate, int upgLevel, KFWeapon KFW)
{
	local WMUpgrade_Skill_Pyromaniac_Helper UPG;

	UPG = GetHelper(KFPawn(KFW.Owner), upgLevel);
	if (UPG != None && UPG.bEnable)
		InRate = DefaultRate / (DefaultRate / InRate + default.RateOfFire[upgLevel - 1]);
}

static simulated function WMUpgrade_Skill_Pyromaniac_Helper GetHelper(KFPawn OwnerPawn, int upgLevel)
{
	local WMUpgrade_Skill_Pyromaniac_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Pyromaniac_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		if (OwnerPawn.Role == Role_Authority)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Pyromaniac_Helper', OwnerPawn);
			UPG.StartTimer(upgLevel > 1);
		}
	}

	return UPG;
}

static function WaveEnd(int upgLevel, KFPlayerController KFPC)
{
	local WMUpgrade_Skill_Pyromaniac_Helper UPG;

	UPG = GetHelper(KFPawn(KFPC.Pawn), upgLevel);
	UPG.EndWaveReset();
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_Pyromaniac_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Pyromaniac_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	RateOfFire(0)=0.2f
	RateOfFire(1)=0.4f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Pyromaniac"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Pyromaniac'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Pyromaniac_Deluxe'

	Name="Default__WMUpgrade_Skill_Pyromaniac"
}
