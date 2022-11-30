class WMWeap_AutoTurret extends KFWeap_AutoTurret;

var class<KFPawn_AutoTurret> TurretPawn;
var class<KFWeapon> TurretWeapon;

var int MaxTurretsDeployedZedternal;

simulated event PreBeginPlay()
{
	super(KFWeap_ThrownBase).PreBeginPlay();

	default.TurretWeapon.static.TriggerAsyncContentLoad(default.TurretWeapon);
}

simulated function Projectile ProjectileFire()
{
	local vector SpawnLocation, SpawnDirection;
	local KFPawn_AutoTurret SpawnedActor;

	if (Role == ROLE_Authority && CurrentFireMode == DEFAULT_FIREMODE)
	{
		GetTurretSpawnLocationAndDir(SpawnLocation, SpawnDirection);
		SpawnedActor = Spawn(default.TurretPawn, self, , SpawnLocation + (TurretSpawnOffset >> Rotation), Rotation, , True);

		if (SpawnedActor != None)
		{
			SpawnedActor.OwnerWeapon = self;
			SpawnedActor.SetPhysics(PHYS_Falling);
			SpawnedActor.Velocity = SpawnDirection * ThrowStrength;
			SpawnedActor.UpdateInstigator(Instigator);
			SpawnedActor.UpdateWeaponUpgrade(CurrentWeaponUpgradeIndex);
			SpawnedActor.SetTurretState(ETS_Throw);

			KFPC.DeployedTurrets.AddItem(SpawnedActor);
			NumDeployedTurrets = KFPC.DeployedTurrets.Length;
			bTurretReadyToUse = False;
			bForceNetUpdate = True;
		}

		return None;
	}
	else
		return super(KFWeap_ThrownBase).ProjectileFire();

	return None;
}

simulated function BeginFire(byte FireModeNum)
{
	local KFPerk InstigatorPerk;
	local int MaxTurrets;

	MaxTurrets = MaxTurretsDeployedZedternal;

	if (FireModeNum == DEFAULT_FIREMODE)
		ClearPendingFire(DETONATE_FIREMODE);

	if (FireModeNum == DETONATE_FIREMODE)
	{
		if (bDetonateLocked)
			return;

		if (NumDeployedTurrets > 0 && bTurretReadyToUse)
			PrepareAndDetonate();
	}
	else
	{
		InstigatorPerk = GetPerk();
		if (WMPerk(InstigatorPerk) != None)
			WMPerk(InstigatorPerk).ModifyMaxDeployed(MaxTurrets, self);

		if (FireModeNum == DEFAULT_FIREMODE
			&& NumDeployedTurrets >= MaxTurrets
			&& HasAnyAmmo())
		{
			if (!bTurretReadyToUse)
				return;

			PrepareAndDetonate();
		}

		super(KFWeap_ThrownBase).BeginFire(FireModeNum);
	}
}

defaultproperties
{
	TurretPawn=class'KFGameContent.KFPawn_AutoTurret';
	TurretWeapon=class'KFGameContent.KFWeap_AutoTurretWeapon';

	MaxTurretsDeployedZedternal=1

	Name="Default__WMWeap_AutoTurret"
}
