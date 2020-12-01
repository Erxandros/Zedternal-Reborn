Class WMUpgrade_Skill_Pyromaniac extends WMUpgrade_Skill;

var array<float> RateOfFire;

static simulated function bool GetIsUberAmmoActive(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Pyromaniac_Counter UPG;

	UPG = GetCounter(OwnerPawn, upgLevel);
	if (UPG != None && UPG.bEnable)
		return True;
	else
		return False;
}

static simulated function ModifyMeleeAttackSpeed(out float InDuration, float DefaultDuration, int upgLevel, KFWeapon KFW)
{
	local WMUpgrade_Skill_Pyromaniac_Counter UPG;

	UPG = GetCounter(KFPawn(KFW.Owner), upgLevel);
	if (UPG != None && UPG.bEnable)
		InDuration = DefaultDuration / (DefaultDuration / InDuration + default.RateOfFire[upgLevel - 1]);
}

static simulated function ModifyRateOfFire(out float InRate, float DefaultRate, int upgLevel, KFWeapon KFW)
{
	local WMUpgrade_Skill_Pyromaniac_Counter UPG;

	UPG = GetCounter(KFPawn(KFW.Owner), upgLevel);
	if (UPG != None && UPG.bEnable)
		InRate = DefaultRate / (DefaultRate / InRate + default.RateOfFire[upgLevel - 1]);
}

static function WMUpgrade_Skill_Pyromaniac_Counter GetCounter(KFPawn OwnerPawn, int upgLevel)
{
	local WMUpgrade_Skill_Pyromaniac_Counter UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Pyromaniac_Counter', UPG)
		{
			if (UPG != None)
				return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Pyromaniac_Counter', OwnerPawn);
		UPG.bDeluxe = (upgLevel > 1);
	}

	return UPG;
}

static function WaveEnd(int upgLevel, KFPlayerController KFPC)
{
	local WMUpgrade_Skill_Pyromaniac_Counter UPG;

	UPG = GetCounter(KFPawn(KFPC.Pawn), upgLevel);
	UPG.EndWaveReset();
}

defaultproperties
{
	RateOfFire(0)=0.2f
	RateOfFire(1)=0.4f

	upgradeName="Pyromaniac"
	upgradeDescription(0)="When you are near 4 or more ZEDs, you shoot with unlimited ammo and 20% faster with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="When you are near <font color=\"#b346ea\">3</font> or more ZEDs, you shoot with unlimited ammo and <font color=\"#b346ea\">40%</font> faster with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Pyromaniac'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Pyromaniac_Deluxe'

	Name="Default__WMUpgrade_Skill_Pyromaniac"
}
