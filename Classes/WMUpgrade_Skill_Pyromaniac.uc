Class WMUpgrade_Skill_Pyromaniac extends WMUpgrade_Skill;
	
var array<float> rateOfFire;

static simulated function bool GetIsUberAmmoActive(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Pyromaniac_Counter UPG;
	
	UPG = GetCounter(OwnerPawn, upgLevel);
	if (UPG.bOn)
		return true;
	else
		return false;
}

static simulated function ModifyMeleeAttackSpeed( out float InDuration, float DefaultDuration, int upgLevel, KFWeapon KFW)
{
	local WMUpgrade_Skill_Pyromaniac_Counter UPG;
	
	UPG = GetCounter(KFPawn(KFW.Owner), upgLevel);
	if (UPG.bOn)
		InDuration = DefaultDuration / (DefaultDuration/InDuration + default.rateOfFire[upgLevel-1]);
}

static simulated function ModifyRateOfFire( out float InRate, float DefaultRate, int upgLevel, KFWeapon KFW )
{
	local WMUpgrade_Skill_Pyromaniac_Counter UPG;
	
	UPG = GetCounter(KFPawn(KFW.Owner), upgLevel);
	if (UPG.bOn)
		InRate = DefaultRate / (DefaultRate/InRate + default.rateOfFire[upgLevel-1]);
}

static function WMUpgrade_Skill_Pyromaniac_Counter GetCounter(KFPawn OwnerPawn, int upgLevel)
{
	local WMUpgrade_Skill_Pyromaniac_Counter UPG;

	if (KFPawn_Human(OwnerPawn)!=none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Pyromaniac_Counter',UPG)
			return UPG;
	}
	// should have one
	UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Pyromaniac_Counter',OwnerPawn);
	UPG.bDeluxe = (upgLevel > 1);
	return UPG;
}

static function WaveEnd( int upgLevel, KFPlayerController KFPC)
{
	local WMUpgrade_Skill_Pyromaniac_Counter UPG;
	
	UPG = GetCounter(KFPawn(KFPC.Pawn), upgLevel);
	UPG.ForceTurnOffEffect();
}

defaultproperties
{
	upgradeName="Pyromaniac"
	upgradeDescription(0)="When you are near 4 or more ZEDs, you shoot with unlimited ammo and 20% faster with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="When you are near <font color=\"#b346ea\">3</font> or more ZEDs, you shoot with unlimited ammo and <font color=\"#b346ea\">40%</font> faster with <font color=\"#eaeff7\">all weapons</font>"
	rateOfFire(0)=0.200000;
	rateOfFire(1)=0.400000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Pyromaniac'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Pyromaniac_Deluxe'
}