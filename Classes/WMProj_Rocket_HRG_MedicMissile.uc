class WMProj_Rocket_HRG_MedicMissile extends KFProj_Rocket_HRG_MedicMissile
	hidedropdown;

simulated function bool AllowNuke()
{
	return super(KFProjectile).AllowNuke();
}

simulated function bool AllowDemolitionistConcussive()
{
	return super(KFProjectile).AllowDemolitionistConcussive();
}

simulated function bool AllowDemolitionistExplosionChangeRadius()
{
	return super(KFProjectile).AllowDemolitionistExplosionChangeRadius();
}

simulated function bool CanDud()
{
	return super(KFProj_BallisticExplosive).CanDud();
}

simulated protected function PrepareExplosionTemplate()
{
	super(KFProj_BallisticExplosive).PrepareExplosionTemplate();
}

simulated function AdjustCanDisintigrate()
{
	super(KFProjectile).AdjustCanDisintigrate();
}

defaultproperties
{
	Name="Default__WMProj_Rocket_HRG_MedicMissile"
}
