class WMWeap_AutoTurret_Precious extends KFWeap_AutoTurret;

simulated event PreBeginPlay()
{
	local class<WMWeap_AutoTurretWeapon_Precious> WeaponClass;

	super.PreBeginPlay();

	WeaponClass = class<WMWeap_AutoTurretWeapon_Precious> (DynamicLoadObject(class'ZedternalReborn.WMPawn_AutoTurret_Precious'.default.WeaponDefinition.default.WeaponClassPath, class'Class'));
	WeaponClass.static.TriggerAsyncContentLoad(WeaponClass);
}

simulated function Projectile ProjectileFire()
{
	local vector SpawnLocation, SpawnDirection;
	local KFPawn_AutoTurret SpawnedActor;

	if (Role == ROLE_Authority && CurrentFireMode == DEFAULT_FIREMODE)
	{
		GetTurretSpawnLocationAndDir(SpawnLocation, SpawnDirection);
		SpawnedActor = Spawn(class'ZedternalReborn.WMPawn_AutoTurret_Precious', self, , SpawnLocation + (TurretSpawnOffset >> Rotation), Rotation, , True);

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
			bForceNetUpdate = True;
		}

		return None;
	}
	else
	{
		return super.ProjectileFire();
	}

	return None;
}

defaultproperties
{
	SpareAmmoCapacity(0)=8
	InstantHitDamage(BASH_FIREMODE)=36
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AutoTurret_Precious"
}
