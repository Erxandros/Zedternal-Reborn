Class WMUpgrade_Skill_ShootAndRun extends WMUpgrade_Skill;
	
var array<float> maxReloadSpeedBonus;
var array<float> maxMoveSpeedBonus;
	
static simulated function GetReloadRateScale( out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Counter UPG;
	
	UPG = GetCounter(OwnerPawn);
	if (UPG.killedZed > 0)
		InReloadRateScale = 1 / (1/InReloadRateScale + default.maxReloadSpeedBonus[upgLevel-1] * (UPG.killedZed / UPG.default.maxKilledZed));
}

static simulated function ModifySpeed( out float InSpeed, float DefaultSpeed, int upgLevel, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Counter UPG;
	
	UPG = GetCounter(OwnerPawn);
	if (UPG.killedZed > 0)
		InSpeed += DefaultSpeed * default.maxMoveSpeedBonus[upgLevel-1] * (UPG.killedZed / UPG.default.maxKilledZed);
}

static function AddVampireHealth( out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT )
{
	local WMUpgrade_Skill_ShootAndRun_Counter UPG;
	if (KFPawn(KFPC.Pawn) != none)
	{
		UPG = GetCounter(KFPawn(KFPC.Pawn));
		UPG.IncreaseCounter();
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Counter UPG;
	local bool bFound;
	
	if (KFPawn_Human(OwnerPawn)!=none)
	{
		bFound = false;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_ShootAndRun_Counter',UPG)
			bFound = true;
		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_ShootAndRun_Counter',OwnerPawn);
	}
}

static simulated function WMUpgrade_Skill_ShootAndRun_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_ShootAndRun_Counter UPG;

	if (KFPawn_Human(OwnerPawn)!=none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_ShootAndRun_Counter',UPG)
			return UPG;
	}
	// should have one
	UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_ShootAndRun_Counter',OwnerPawn);
	return UPG;
}

defaultproperties
{
	upgradeName="Shoot and Run"
	upgradeDescription(0)="Increase reload speed up to 50% and movement speed up to 20% for a short time while killing ZEDs"
	upgradeDescription(1)="Increase reload speed up to <font color=\"#b346ea\">125%</font> and movement speed up to <font color=\"#b346ea\">50%</font> for a short time while killing ZEDs"
	maxReloadSpeedBonus(0)=0.500000;
	maxReloadSpeedBonus(1)=1.250000;
	maxMoveSpeedBonus(0)=0.200000;
	maxMoveSpeedBonus(1)=0.500000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ShootAndRun'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ShootAndRun_Deluxe'
}