class WMPawn_AutoTurret extends KFPawn_AutoTurret
	notplaceable;

var bool bAmmoSet;

simulated function bool PawnCloakingStatus(const out KFPawn_Monster Target)
{
	if (OwnerWeapon != None && OwnerWeapon.GetPerk() != None && WMPerk(OwnerWeapon.GetPerk()) != None)
	{
		if (WMPerk(OwnerWeapon.GetPerk()).CanSeeCloaked(OwnerWeapon))
			return False;
	}

	return Target.bIsCloaking && (Target.bIsCloakingSpottedByLP || Target.bIsCloakingSpottedByTeam) == False;
}

simulated function UpdateWeaponUpgrade(int UpgradeIndex)
{
	if (Weapon != None)
	{
		TurretWeapon.SetWeaponUpgradeLevel(UpgradeIndex);

		if (!bAmmoSet)
		{
			TurretWeapon.AmmoCount[0] = TurretWeapon.MagazineCapacity[0];
			bAmmoSet = True;
		}
	}
}

simulated state Combat
{
	simulated event Tick(float DeltaTime)
	{
		local vector MuzzleLoc;
		local rotator MuzzleRot;
		local rotator DesiredRotationRot;

		local float NewAmmoPercentage;

		if (Role == ROLE_Authority)
		{
			TurretWeapon.GetMuzzleLocAndRot(MuzzleLoc, MuzzleRot);

			NewAmmoPercentage = float(TurretWeapon.AmmoCount[0]) / TurretWeapon.MagazineCapacity[0];

			if (NewAmmoPercentage != CurrentAmmoPercentage)
			{
				CurrentAmmoPercentage = NewAmmoPercentage;

				if (WorldInfo.NetMode == NM_Standalone)
					UpdateTurretMeshMaterialColor(CurrentAmmoPercentage);
				else
					bNetDirty = True;
			}
		}
		else
			WeaponAttachment.WeapMesh.GetSocketWorldLocationAndRotation('MuzzleFlash', MuzzleLoc, MuzzleRot);

		if (Role == ROLE_Authority)
		{
			if (EnemyTarget != None)
			{
				if (EnemyTarget.IsAliveAndWell() == False
					|| PawnCloakingStatus(EnemyTarget)
					|| EnemyTarget.GetTeamNum() != 255
					|| VSizeSq(EnemyTarget.Location - Location) > EffectiveRadius * EffectiveRadius
					|| TargetValidWithGeometry(EnemyTarget, MuzzleLoc, EnemyTarget.Mesh.GetBoneLocation('Spine1')))
				{
					EnemyTarget = None;
					CheckForTargets();

					if (EnemyTarget == None)
					{
						SetTurretState(ETS_TargetSearch);
						return;
					}
				}
			}
		}

		if (EnemyTarget != None)
		{
			DesiredRotationRot = rotator(Normal(EnemyTarget.Mesh.GetBoneLocation('Spine1') - MuzzleLoc));
			DesiredRotationRot.Roll = 0;

			RotateBySpeed(DesiredRotationRot);

			if (Role == ROLE_Authority && ReachedRotation())
			{
				if (TurretWeapon != None)
				{
					if (TargetValidWithGeometry(EnemyTarget, MuzzleLoc, EnemyTarget.Mesh.GetBoneLocation('Spine1')))
					{
						TurretWeapon.Fire();

						if (!TurretWeapon.HasAmmo(0))
							SetTurretState(ETS_Empty);
					}
					else
						TurretWeapon.StopFire(0);
				}
			}
		}

		global.Tick(DeltaTime);
	}
}

function CheckForTargets()
{
	local KFPawn_Monster CurrentTarget;
	local TraceHitInfo HitInfo;

	local float CurrentDistance;
	local float Distance;

	local vector MuzzleLoc;
	local rotator MuzzleRot;

	if (EnemyTarget != None)
		CurrentDistance = VSizeSq(Location - EnemyTarget.Location);
	else
		CurrentDistance = 9999.0f;

	TurretWeapon.GetMuzzleLocAndRot(MuzzleLoc, MuzzleRot);

	SetCollisionType(COLLIDE_CustomDefault);

	foreach CollidingActors(class'KFPawn_Monster', CurrentTarget, EffectiveRadius, Location, True, , HitInfo)
	{
		if (!CurrentTarget.IsAliveAndWell() || CurrentTarget.GetTeamNum() != 255 || PawnCloakingStatus(CurrentTarget))
			continue;

		if (TargetValidWithGeometry(CurrentTarget, MuzzleLoc, CurrentTarget.Mesh.GetBoneLocation('Spine1')) == False)
			continue;

		Distance = VSizeSq(Location - CurrentTarget.Location);

		if (EnemyTarget == None)
		{
			EnemyTarget = CurrentTarget;
			CurrentDistance = Distance;
		}
		else if (CurrentDistance > Distance)
		{
			EnemyTarget = CurrentTarget;
			CurrentDistance = Distance;
		}
	}

	SetCollisionType(COLLIDE_NoCollision);

	if (EnemyTarget != None)
		SetTurretState(ETS_Combat);
}

defaultproperties
{
	bAmmoSet=False

	Name="Default__WMPawn_AutoTurret"
}
