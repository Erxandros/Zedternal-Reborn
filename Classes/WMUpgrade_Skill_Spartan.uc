Class WMUpgrade_Skill_Spartan extends WMUpgrade_Skill;

var array<float> FireRate, SpecialRate;
var array<name> ZedTimeModifyingStates;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	if (KFPawn_Human(OwnerPawn) != None)
		OwnerPawn.bMovesFastInZedTime = True;
}

static simulated function GetZedTimeModifier(out float InModifier, int upgLevel, KFWeapon KFW)
{
	local name StateName;

	if (KFW != None)
	{
		StateName = KFW.GetStateName();
		if (default.ZedTimeModifyingStates.Find(StateName) != INDEX_NONE)
		{
			if (KFWeap_MeleeBase(KFW) != None || KFW.default.MagazineCapacity[0] > 4)
				InModifier += default.FireRate[upgLevel - 1];
			else
				InModifier += default.SpecialRate[upgLevel - 1];
		}
	}
}

defaultproperties
{
	FireRate(0)=0.6f
	FireRate(1)=1.2f
	SpecialRate(0)=0.2f
	SpecialRate(1)=0.4f

	//Melee Attacks
	ZedTimeModifyingStates(0)="MeleeChainAttacking"
	ZedTimeModifyingStates(1)="MeleeAttackBasic"
	ZedTimeModifyingStates(2)="MeleeHeavyAttacking"
	ZedTimeModifyingStates(3)="MeleeSustained"

	//Weapon Attacks
	ZedTimeModifyingStates(4)="WeaponFiring"
	ZedTimeModifyingStates(5)="WeaponAltFiring"
	ZedTimeModifyingStates(6)="WeaponAltFiringAuto"
	ZedTimeModifyingStates(7)="WeaponBurstFiring"
	ZedTimeModifyingStates(8)="WeaponSingleFiring"
	ZedTimeModifyingStates(9)="WeaponSingleFireAndReload"
	ZedTimeModifyingStates(10)="WeaponThrowing"
	ZedTimeModifyingStates(11)="WeaponWindingUp"

	//Special Attacks
	ZedTimeModifyingStates(12)="SprayingFire"
	ZedTimeModifyingStates(13)="FiringSecondaryState"
	ZedTimeModifyingStates(14)="HuskCannonCharge"
	ZedTimeModifyingStates(15)="BlunderbussDeployAndDetonate"
	ZedTimeModifyingStates(16)="CompoundBowCharge"
	ZedTimeModifyingStates(17)="MineReconstructorCharge"

	upgradeName="Spartan"
	upgradeDescription(0)="You move and attack faster during Zed time"
	upgradeDescription(1)="You move and attack <font color=\"#b346ea\">insanely</font> fast during Zed time"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Spartan'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Spartan_Deluxe'

	Name="Default__WMUpgrade_Skill_Spartan"
}
