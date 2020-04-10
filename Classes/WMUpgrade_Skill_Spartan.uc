Class WMUpgrade_Skill_Spartan extends WMUpgrade_Skill;
	
var array<float> fireRate, specialRate;
var array<name> ZedTimeModifyingStates;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	if (OwnerPawn != none)
		OwnerPawn.bMovesFastInZedTime = true;
}

static simulated function GetZedTimeModifier(out float InModifier, int upgLevel, KFWeapon KFW)
{
	local name StateName;
	
	if(KFW != none)
	{
		StateName = KFW.GetStateName();
		if (default.ZedTimeModifyingStates.Find( StateName ) != INDEX_NONE)
		{
			if (KFWeap_MeleeBase(KFW) != none || KFW.default.MagazineCapacity[0] > 4)
				InModifier += default.fireRate[upgLevel-1];
			else
				InModifier += default.specialRate[upgLevel-1];
		}
	}
}
	
defaultproperties
{
	upgradeName="Spartan"
	upgradeDescription(0)="You move and attack faster during Zed time"
	upgradeDescription(1)="You move and attack <font color=\"#b346ea\">insanely</font> faster during Zed time"
	fireRate(0)=0.600000;
	fireRate(1)=1.200000;
	specialRate(0)=0.200000;
	specialRate(1)=0.400000;
	ZedTimeModifyingStates(0)="MeleeChainAttacking"
    ZedTimeModifyingStates(1)="MeleeAttackBasic"
    ZedTimeModifyingStates(2)="MeleeHeavyAttacking"
    ZedTimeModifyingStates(3)="MeleeSustained"
    ZedTimeModifyingStates(4)="WeaponFiring"
	ZedTimeModifyingStates(5)="WeaponBurstFiring"
    ZedTimeModifyingStates(6)="WeaponSingleFiring"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Spartan'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Spartan_Deluxe'
}