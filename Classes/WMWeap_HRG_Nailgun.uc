class WMWeap_HRG_Nailgun extends KFWeap_HRG_Nailgun;

/** Returns number of projectiles to fire from SpawnProjectile */
simulated function byte GetNumProjectilesToFire(byte FireModeNum)
{
	local KFPerk InstigatorPerk;

	InstigatorPerk = GetPerk();
	if(InstigatorPerk != none && InstigatorPerk.GetIsUberAmmoActive(self))
	{
		return NumPellets[CurrentFireMode];
	}

	return super.GetNumProjectilesToFire(FireModeNum);
}

defaultproperties
{
	Name="Default__WMWeap_HRG_Nailgun"
}
