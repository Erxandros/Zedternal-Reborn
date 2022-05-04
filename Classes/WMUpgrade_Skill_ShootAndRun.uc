class WMUpgrade_Skill_ShootAndRun extends WMUpgrade_Skill;

var array<float> MaxReloadSpeedBonus;
var array<float> MaxMoveSpeedBonus;

static simulated function GetReloadRateScale(out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Helper UPG;

	UPG = GetHelper(OwnerPawn);
	if (UPG != None && UPG.KilledZeds > 0)
		InReloadRateScale = 1.0f / (1.0f / InReloadRateScale + default.MaxReloadSpeedBonus[upgLevel - 1] * UPG.GetKillPercentage());
}

static simulated function ModifySpeed(out float InSpeed, float DefaultSpeed, int upgLevel, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Helper UPG;

	UPG = GetHelper(OwnerPawn);
	if (UPG != None && UPG.KilledZeds > 0)
		InSpeed += DefaultSpeed * default.MaxMoveSpeedBonus[upgLevel - 1] * UPG.GetKillPercentage();
}

static function AddVampireHealth(out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT)
{
	local WMUpgrade_Skill_ShootAndRun_Helper UPG;

	if (KFPawn(KFPC.Pawn) != None)
	{
		UPG = GetHelper(KFPawn(KFPC.Pawn));
		if (UPG != None)
			UPG.IncreaseCounter();
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_ShootAndRun_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_ShootAndRun_Helper', OwnerPawn);
	}
}

static simulated function WMUpgrade_Skill_ShootAndRun_Helper GetHelper(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_ShootAndRun_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		if (OwnerPawn.Role == Role_Authority)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_ShootAndRun_Helper', OwnerPawn);
	}

	return UPG;
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_ShootAndRun_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	MaxReloadSpeedBonus(0)=0.5f
	MaxReloadSpeedBonus(1)=1.25f
	MaxMoveSpeedBonus(0)=0.2f
	MaxMoveSpeedBonus(1)=0.5f

	UpgradeName="Shoot And Run"
	UpgradeDescription(0)="Over time increase reload speed up to 50% and movement speed up to 20% while actively killing ZEDs"
	UpgradeDescription(1)="Over time increase reload speed up to <font color=\"#b346ea\">125%</font> and movement speed up to <font color=\"#b346ea\">50%</font> while actively killing ZEDs"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ShootAndRun'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ShootAndRun_Deluxe'

	Name="Default__WMUpgrade_Skill_ShootAndRun"
}
