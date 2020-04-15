class WMWeap_Shotgun_Nailgun extends KFWeap_Shotgun_Nailgun;

simulated function ConsumeAmmo( byte FireModeNum )
{
    local int AmountToConsume;
    local KFPerk InstigatorPerk;

`if(`notdefined(ShippingPC))
    if( bInfiniteAmmo )
    {
        return;
    }
`endif

	InstigatorPerk = GetPerk();
	if( InstigatorPerk != none && InstigatorPerk.GetIsUberAmmoActive( self ) )
	{
		return;
	}

	// If AmmoCount is being replicated, don't allow the client to modify it here
	if ( Role == ROLE_Authority || bAllowClientAmmoTracking )
	{
		// Don't consume ammo if magazine size is 0 (infinite ammo with no reload)
		if (MagazineCapacity[GetAmmoType(FireModeNum)] > 0 && AmmoCount[GetAmmoType(FireModeNum)] > 0)
		{
			// Only consume up to the number of nails left
            AmountToConsume = Min( NumPellets[CurrentFireMode], AmmoCount[GetAmmoType(FireModeNum)] );
            AmmoCount[GetAmmoType(FireModeNum)]-=AmountToConsume;
		}
	}
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