Class WMUpgrade_Skill_ShootAndRun extends WMUpgrade_Skill;

var array<float> MaxReloadSpeedBonus;
var array<float> MaxMoveSpeedBonus;

static simulated function GetReloadRateScale(out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Counter UPG;

	UPG = GetCounter(OwnerPawn);
	if (UPG != None && UPG.killedZed > 0)
		InReloadRateScale = 1.0f / (1.0f / InReloadRateScale + default.MaxReloadSpeedBonus[upgLevel - 1] * (UPG.killedZed / UPG.default.maxKilledZed));
}

static simulated function ModifySpeed(out float InSpeed, float DefaultSpeed, int upgLevel, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Counter UPG;

	UPG = GetCounter(OwnerPawn);
	if (UPG != None && UPG.killedZed > 0)
		InSpeed += DefaultSpeed * default.MaxMoveSpeedBonus[upgLevel - 1] * (UPG.killedZed / UPG.default.maxKilledZed);
}

static function AddVampireHealth(out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT)
{
	local WMUpgrade_Skill_ShootAndRun_Counter UPG;

	if (KFPawn(KFPC.Pawn) != None)
	{
		UPG = GetCounter(KFPawn(KFPC.Pawn));
		if (UPG != None)
			UPG.IncreaseCounter();
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Counter UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_ShootAndRun_Counter', UPG)
		{
			if (UPG != None)
			{
				bFound = True;
				break;
			}
		}
		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_ShootAndRun_Counter', OwnerPawn);
	}
}

static simulated function WMUpgrade_Skill_ShootAndRun_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Counter UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_ShootAndRun_Counter', UPG)
		{
			if (UPG != None)
				return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_ShootAndRun_Counter', OwnerPawn);
	}

	return UPG;
}

defaultproperties
{
	MaxReloadSpeedBonus(0)=0.5f
	MaxReloadSpeedBonus(1)=1.25f
	MaxMoveSpeedBonus(0)=0.2f
	MaxMoveSpeedBonus(1)=0.5f

	upgradeName="Shoot and Run"
	upgradeDescription(0)="Increase reload speed up to 50% and movement speed up to 20% for a short time while killing ZEDs"
	upgradeDescription(1)="Increase reload speed up to <font color=\"#b346ea\">125%</font> and movement speed up to <font color=\"#b346ea\">50%</font> for a short time while killing ZEDs"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ShootAndRun'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ShootAndRun_Deluxe'

	Name="Default__WMUpgrade_Skill_ShootAndRun"
}
