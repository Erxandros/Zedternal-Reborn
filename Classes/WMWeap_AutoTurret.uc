class WMWeap_AutoTurret extends KFWeap_AutoTurret implements(WMTurret_Interface);

var class<KFPawn_AutoTurret> TurretPawn;
var class<KFWeapon> TurretWeapon;

var int MaxTurretsDeployedZedternal;

simulated event PreBeginPlay()
{
	super(KFWeap_ThrownBase).PreBeginPlay();

	default.TurretWeapon.static.TriggerAsyncContentLoad(default.TurretWeapon);
}

simulated event PostBeginPlay()
{
	super(KFWeap_ThrownBase).PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		KFPC = KFPlayerController(Instigator.Controller);
		NumDeployedTurrets = GetDeployedTurretCount();
	}
}
////////////////////////////////////////////////////////////
//// Turret Helper Functions
simulated function int GetDeployedTurretCount()
{
	local int i, num;

	num = 0;
	for (i = 0; i < KFPC.DeployedTurrets.Length; ++i)
	{
		if (KFPC.DeployedTurrets[i].Owner == self)
			num++;
	}

	return num;
}

simulated function GetAllTurrets(out array<Actor> TurretsList)
{
	local int i;

	for (i = 0; i < KFPC.DeployedTurrets.Length; ++i)
	{
		if (KFPC.DeployedTurrets[i].Owner == self)
			TurretsList.AddItem(KFPC.DeployedTurrets[i]);
	}
}

simulated function int GetMaxTurrets()
{
	local KFPerk InstigatorPerk;
	local int MaxTurrets;

	MaxTurrets = default.MaxTurretsDeployedZedternal;

	InstigatorPerk = GetPerk();
	if (WMPerk(InstigatorPerk) != None)
		WMPerk(InstigatorPerk).ModifyMaxDeployed(MaxTurrets, self);

	return MaxTurrets;
}
////////////////////////////////////////////////////////////

function RemoveDeployedTurret(optional int Index = INDEX_NONE, optional Actor TurretActor)
{
	if (Index == INDEX_NONE)
	{
		if (TurretActor != None)
			Index = KFPC.DeployedTurrets.Find(TurretActor);
	}

	if (Index != INDEX_NONE)
	{
		KFPC.DeployedTurrets.Remove(Index, 1);
		NumDeployedTurrets = GetDeployedTurretCount();
		bForceNetUpdate = True;
	}
}

function SetOriginalValuesFromPickup(KFWeapon PickedUpWeapon)
{
	local int i;
	local Actor WeaponPawn;

	super(KFWeap_ThrownBase).SetOriginalValuesFromPickup(PickedUpWeapon);

	if (PickedUpWeapon.KFPlayer != None && PickedUpWeapon.KFPlayer != KFPC)
	{
		for (i = 0; i < PickedUpWeapon.KFPlayer.DeployedTurrets.Length; ++i)
		{
			if (PickedUpWeapon.KFPlayer.DeployedTurrets[i].Owner == PickedUpWeapon)
			{
				KFPC.DeployedTurrets.AddItem(PickedUpWeapon.KFPlayer.DeployedTurrets[i]);
				PickedUpWeapon.KFPlayer.DeployedTurrets.Remove(i, 1);
				i--;
			}
		}
	}

	for (i = 0; i < KFPC.DeployedTurrets.Length; ++i)
	{
		WeaponPawn = KFPC.DeployedTurrets[i];
		if (WeaponPawn != None && (WeaponPawn.Owner == None || WeaponPawn.Owner == PickedUpWeapon))
		{
			WeaponPawn.Instigator = Instigator;
			WeaponPawn.SetOwner(self);

			if (Instigator.Controller != None)
				KFPawn_AutoTurret(KFPC.DeployedTurrets[i]).InstigatorController = Instigator.Controller;
		}
	}

	if (GetDeployedTurretCount() > 1)
		Detonate(True);

	PickedUpWeapon.KFPlayer = None;

	NumDeployedTurrets = GetDeployedTurretCount();
	bForceNetUpdate = True;
}

simulated function Projectile ProjectileFire()
{
	local vector SpawnLocation, SpawnDirection;
	local KFPawn_AutoTurret SpawnedActor;

	if (Role != ROLE_Authority)
		return None;

	if (CurrentFireMode == DEFAULT_FIREMODE)
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

			if (KFPC != None)
			{
				KFPC.DeployedTurrets.AddItem(SpawnedActor);
				NumDeployedTurrets = GetDeployedTurretCount();
			}

			bTurretReadyToUse = False;
			bForceNetUpdate = True;
		}

		return None;
	}

	return super(KFWeap_ThrownBase).ProjectileFire();
}

simulated function DetonateFinished()
{
	SetReadyToUse(True);

	if (!HasAnyAmmo() && NumDeployedTurrets == 0)
	{
		if (CanSwitchWeapons())
			Instigator.Controller.ClientSwitchToBestWeapon(False);
	}
}

simulated function Detonate(optional bool bKeepTurret = False)
{
	local int i, MaxTurrets;
	local array<Actor> TurretsCopy;

	if (Role == ROLE_Authority)
	{
		if (bKeepTurret)
			MaxTurrets = GetMaxTurrets();
		else // Blow them all up
			MaxTurrets = 0;

		GetAllTurrets(TurretsCopy);
		for (i = 0; i < TurretsCopy.Length; ++i)
		{
			if (bKeepTurret && i >= (TurretsCopy.Length - MaxTurrets))
				continue;

				KFPawn_Autoturret(TurretsCopy[i]).SetTurretState(ETS_Detonate);
		}

		DetonateFinished();
	}
}

simulated function DetonateExcess()
{
	local int i, MaxTurrets;
	local array<Actor> TurretsCopy;

	if (Role == ROLE_Authority)
	{
		MaxTurrets = GetMaxTurrets();

		GetAllTurrets(TurretsCopy);
		for (i = 0; i < TurretsCopy.Length; ++i)
		{
			if (i > (TurretsCopy.Length - MaxTurrets))
				continue;

			KFPawn_AutoTurret(TurretsCopy[i]).SetTurretState(ETS_Detonate);
		}

		DetonateFinished();
	}
}

simulated function BeginFire(byte FireModeNum)
{
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
		if (KFPC != None)
			NumDeployedTurrets = GetDeployedTurretCount();

		if (FireModeNum == DEFAULT_FIREMODE
			&& NumDeployedTurrets >= GetMaxTurrets()
			&& HasAnyAmmo())
		{
			if (!bTurretReadyToUse)
				return;

			PrepareAndDetonateExcess();
		}

		super(KFWeap_ThrownBase).BeginFire(FireModeNum);
	}
}

simulated function PrepareAndDetonateExcess()
{
	local name DetonateAnimName;
	local float AnimDuration;
	local bool bInSprintState;

	DetonateAnimName = ShouldPlayLastAnims() ? DetonateLastAnim : DetonateAnim;
	AnimDuration = MySkelMesh.GetAnimLength(DetonateAnimName);
	bInSprintState = IsInState('WeaponSprinting');

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (NumDeployedTurrets > 0)
			PlaySoundBase(DetonateAkEvent, True);

		if (bInSprintState)
		{
			AnimDuration *= 0.25f;
			PlayAnimation(DetonateAnimName, AnimDuration);
		}
		else
			PlayAnimation(DetonateAnimName);
	}

	if (Role == ROLE_Authority)
		DetonateExcess();

	CurrentFireMode = DETONATE_FIREMODE;
	IncrementFlashCount();

	if (bInSprintState)
		SetTimer(AnimDuration * 0.8f, False, NameOf(PlaySprintStart));
	else
		SetTimer(AnimDuration * 0.5f, False, NameOf(GotoActiveState));
}

function CheckTurretAmmo()
{
	local float Percentage;
	local KFWeapon KFW;
	local KFPawn KFP;
	local array<Actor> TurretsCopy;

	if (Role == Role_Authority)
	{
		if (KFPC == None)
			return;

		GetAllTurrets(TurretsCopy);

		if (TurretsCopy.Length > 0)
		{
			KFW = KFWeapon(KFPawn(TurretsCopy[0]).Weapon);
			if (KFW != None)
			{
				Percentage = float(KFW.AmmoCount[0]) / float(KFW.MagazineCapacity[0]);
				if (Percentage != CurrentAmmoPercentage)
				{
					CurrentAmmoPercentage = Percentage;
					bNetDirty = True;

					if (WorldInfo.NetMode == NM_Standalone)
						UpdateMaterialColor(CurrentAmmoPercentage);
					else
					{
						KFP = KFPawn(Instigator);
						if (KFP != None)
							KFP.OnWeaponSpecialAction(1 + (CurrentAmmoPercentage * 100));
					}
				}
			}
		}
	}
}

defaultproperties
{
	TurretPawn=class'ZedternalReborn.WMPawn_AutoTurret';
	TurretWeapon=class'KFGameContent.KFWeap_AutoTurretWeapon';

	MaxTurretsDeployedZedternal=1

	Name="Default__WMWeap_AutoTurret"
}
