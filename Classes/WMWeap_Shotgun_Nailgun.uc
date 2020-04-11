class WMWeap_Shotgun_Nailgun extends KFWeap_Shotgun_Nailgun;

simulated function ConsumeAmmo( byte FireModeNum )
{
	local KFPerk InstigatorPerk;

`if(`notdefined(ShippingPC))
	if (bInfiniteAmmo)
	{
		return;
	}
`endif

	InstigatorPerk = GetPerk();
	if (InstigatorPerk != none && InstigatorPerk.GetIsUberAmmoActive(self))
	{
		return;
	}

	super.ConsumeAmmo(FireModeNum);
}

/** Returns number of projectiles to fire from SpawnProjectile */
simulated function byte GetNumProjectilesToFire(byte FireModeNum)
{
    local KFPerk InstigatorPerk;
	
	InstigatorPerk = GetPerk();
	if( InstigatorPerk != none && InstigatorPerk.GetIsUberAmmoActive( self ) )
	{
		return NumPellets[CurrentFireMode];
	}
	
	return Min( NumPellets[CurrentFireMode], AmmoCount[GetAmmoType(CurrentFireMode)] );
}

defaultproperties
{
}