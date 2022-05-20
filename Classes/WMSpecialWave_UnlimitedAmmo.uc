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

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_UnlimitedAmmo"

	Name="Default__WMSpecialWave_UnlimitedAmmo"
}
