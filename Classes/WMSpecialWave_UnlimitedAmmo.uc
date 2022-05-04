class WMSpecialWave_UnlimitedAmmo extends WMSpecialWave;

static simulated function bool GetIsUberAmmoActive(KFWeapon KFW, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	ZedSpawnRateFactor=4.0f
	WaveValueFactor=1.75f
	DoshFactor=0.55f

	Title="Unlimited Ammo"
	Description="Spread some love!"

	Name="Default__WMSpecialWave_UnlimitedAmmo"
}
