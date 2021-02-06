class WMSpecialWave_UnlimitedAmmo extends WMSpecialWave;

static simulated function bool GetIsUberAmmoActive(KFWeapon KFW, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	zedSpawnRateFactor=4.0f
	waveValueFactor=1.75f
	doshFactor=0.55f

	Title="Unlimited Ammo"
	Description="Spread some love!"

	Name="Default__WMSpecialWave_UnlimitedAmmo"
}
