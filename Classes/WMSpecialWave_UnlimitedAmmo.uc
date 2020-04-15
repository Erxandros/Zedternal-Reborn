class WMSpecialWave_UnlimitedAmmo extends WMSpecialWave;

static simulated function bool GetIsUberAmmoActive(KFWeapon KFW, KFPawn OwnerPawn)
{
	return true;
}

defaultproperties
{
   Title="Unlimited Ammo"
   Description="Spread some love!"
   zedSpawnRateFactor=4.000000
   waveValueFactor=1.750000
   doshFactor=0.550000
   Name="Default__WMSpecialWave_UnlimitedAmmo"
}
