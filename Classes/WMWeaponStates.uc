class WMWeaponStates extends Object;

var array<name> WeaponAttackStates;
var array<name> WeaponReloadStates;
var array<name> WeaponSwitchStates;

static simulated function bool IsWeaponAttackState(name StateName)
{
	return default.WeaponAttackStates.Find(StateName) != INDEX_NONE;
}

static simulated function bool IsWeaponReloadState(name StateName)
{
	return default.WeaponReloadStates.Find(StateName) != INDEX_NONE;
}

static simulated function bool IsWeaponSwitchState(name StateName)
{
	return default.WeaponSwitchStates.Find(StateName) != INDEX_NONE;
}

defaultproperties
{
	WeaponAttackStates(0)="BlockingCooldown"
	WeaponAttackStates(1)="BlunderbussDeployAndDetonate"
	WeaponAttackStates(2)="CompoundBowCharge"
	WeaponAttackStates(3)="FiringSecondaryState"
	WeaponAttackStates(4)="FiringSuctioning"
	WeaponAttackStates(5)="GrenadeFiring"
	WeaponAttackStates(6)="HuskCannonCharge"
	WeaponAttackStates(7)="LazerCharge"
	WeaponAttackStates(8)="MeleeAttackBasic"
	WeaponAttackStates(9)="MeleeBlocking"
	WeaponAttackStates(10)="MeleeChainAttacking"
	WeaponAttackStates(11)="MeleeHeavyAttacking"
	WeaponAttackStates(12)="MeleeSustained"
	WeaponAttackStates(13)="MineReconstructorCharge"	
	WeaponAttackStates(14)="SprayingFire"
	WeaponAttackStates(15)="SprayingFireLazer"
	WeaponAttackStates(16)="UltimateAttackState"
	WeaponAttackStates(17)="WeaponAltFiring"
	WeaponAttackStates(18)="WeaponAltFiringAuto"
	WeaponAttackStates(19)="WeaponBurstFiring"
	WeaponAttackStates(20)="WeaponDetonating"
	WeaponAttackStates(21)="WeaponDoubleBarrelFiring"
	WeaponAttackStates(22)="WeaponFiring"
	WeaponAttackStates(23)="WeaponHealing"
	WeaponAttackStates(24)="WeaponQuadBarrelFiring"
	WeaponAttackStates(25)="WeaponSingleFireAndReload"
	WeaponAttackStates(26)="WeaponSingleFiring"
	WeaponAttackStates(27)="WeaponSonicGunCharging"
	WeaponAttackStates(28)="WeaponSonicGunSingleFiring"
	WeaponAttackStates(29)="WeaponThrowing"
	WeaponAttackStates(30)="WeaponWindingUp"

	WeaponReloadStates(0)="AltReloading"
	WeaponReloadStates(1)="Reloading"
	WeaponReloadStates(2)="WeaponUpkeep"

	WeaponSwitchStates(0)="WeaponAbortEquip"
	WeaponSwitchStates(1)="WeaponDownSimple"
	WeaponSwitchStates(2)="WeaponEquipping"
	WeaponSwitchStates(3)="WeaponPuttingDown"

	Name="Default__WMWeaponStates"
}
