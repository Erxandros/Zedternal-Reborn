class WMWeap_HRG_Dragonbreath extends KFWeap_HRG_Dragonbreath;

var transient float DefaultSpread[2];

simulated event PreBeginPlay()
{
	super.PreBeginPlay();

	DefaultSpread[DEFAULT_FIREMODE] = Spread[DEFAULT_FIREMODE];
	DefaultSpread[ALTFIRE_FIREMODE] = Spread[ALTFIRE_FIREMODE];
}

simulated function KFProjectile SpawnAllProjectiles(class<KFProjectile> KFProjClass, vector RealStartLoc, vector AimDir)
{
	local KFPerk InstigatorPerk;
	local int ProjectilesToFire, i;
	local float InitialOffset;

	ProjectilesToFire = GetNumProjectilesToFire(CurrentFireMode);
	if (CurrentFireMode == GRENADE_FIREMODE || ProjectilesToFire <= 1)
		return SpawnProjectile(KFProjClass, RealStartLoc, AimDir);

	InitialOffset = CurrentFireMode == DEFAULT_FIREMODE ? StartingPelletPosition : StartingPelletPositionAlt;

	InstigatorPerk = GetPerk();
	if (InstigatorPerk != None)
	{
		Spread[CurrentFireMode] = DefaultSpread[CurrentFireMode] * InstigatorPerk.GetTightChokeModifier();
		InitialOffset = InitialOffset * InstigatorPerk.GetTightChokeModifier();
	}

	for (i = 0; i < ProjectilesToFire; ++i)
	{
		SpawnProjectile(KFProjClass, RealStartLoc, CalculateSpread(InitialOffset, Spread[CurrentFireMode], i, CurrentFireMode == ALTFIRE_FIREMODE));
		CurrentBarrelHeat = FMin(CurrentBarrelHeat + BarrelHeatPerProjectile, MaxBarrelHeat);
	}

	ChangeBarrelMaterial();
	return None;
}

defaultproperties
{
	Name="Default__WMWeap_HRG_Dragonbreath"
}
