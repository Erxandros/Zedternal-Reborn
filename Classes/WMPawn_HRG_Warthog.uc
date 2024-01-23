class WMPawn_HRG_Warthog extends KFPawn_HRG_Warthog
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

		local vector HitLocation, HitNormal;
		local TraceHitInfo HitInfo;
		local Actor HitActor;

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
				HitActor = Trace(HitLocation, HitNormal, EnemyTarget.Mesh.GetBoneLocation('Spine1'), MuzzleLoc, , , , TRACEFLAG_Bullet);

				if (!EnemyTarget.IsAliveAndWell()
					|| PawnCloakingStatus(EnemyTarget)
					|| VSizeSq(EnemyTarget.Location - Location) > EffectiveRadius * EffectiveRadius
					|| (HitActor != None && HitActor.bWorldGeometry && KFFracturedMeshGlass(HitActor) == None)
					|| EnemyTarget.GetTeamNum() != 255)
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

		if (EnemyTarget != None && ReachedRotation())
		{
			DesiredRotationRot = rotator(Normal(EnemyTarget.Mesh.GetBoneLocation('Spine1') - MuzzleLoc));
			DesiredRotationRot.Roll = 0;

			RotateBySpeed(DesiredRotationRot);

			if (Role == ROLE_Authority)
			{
				HitActor = Trace(HitLocation, HitNormal, MuzzleLoc + vector(Rotation) * EffectiveRadius, MuzzleLoc, , , HitInfo, TRACEFLAG_Bullet);

				if (TurretWeapon != None)
				{
					if (HitActor != None && HitActor.bWorldGeometry == False)
					{
						TurretWeapon.CurrentTarget = EnemyTarget;
						TurretWeapon.Fire();

						if (!TurretWeapon.HasAmmo(0))
							SetTurretState(ETS_Empty);
					}
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

	local vector HitLocation, HitNormal;
	local Actor HitActor;

	if (EnemyTarget != None)
		CurrentDistance = VSizeSq(Location - EnemyTarget.Location);
	else
		CurrentDistance = 9999.0f;

	TurretWeapon.GetMuzzleLocAndRot(MuzzleLoc, MuzzleRot);

	SetCollisionType(COLLIDE_CustomDefault);

	foreach CollidingActors(class'KFPawn_Monster', CurrentTarget, EffectiveRadius, Location, True, , HitInfo)
	{
		if (!CurrentTarget.IsAliveAndWell()
			|| PawnCloakingStatus(CurrentTarget))
		{
			continue;
		}

		HitActor = Trace(HitLocation, HitNormal, CurrentTarget.Mesh.GetBoneLocation('Spine1'), MuzzleLoc, , , , TRACEFLAG_Bullet);

		if (HitActor == None || (HitActor.bWorldGeometry && KFFracturedMeshGlass(HitActor) == None) || HitActor.GetTeamNum() != 255)
        {
            continue;
        }

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

	Name="Default__WMPawn_HRG_Warthog"
}
