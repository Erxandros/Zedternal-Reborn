class WMWeap_Bow_Crossbow_Precious extends KFWeap_Bow_Crossbow;

const VARIANT_SKIN_ID = 4596;

reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	Super.ClientWeaponSet(bOptionalSet, bDoNotActivate);
	class'ZedternalReborn.WMWeaponPrecious_Helper'.static.VariantClientWeaponSet( self, VARIANT_SKIN_ID );
}

function SetOriginalValuesFromPickup( KFWeapon PickedUpWeapon )
{
	class'ZedternalReborn.WMWeaponPrecious_Helper'.static.VariantSetOriginalValuesFromPickup( self, PickedUpWeapon, VARIANT_SKIN_ID );
}

/** Returns an anim rate scale for reloading */
simulated function float GetReloadRateScale()
{
	local float Rate;
	local KFPerk MyPerk;

	Rate = 0.85f;

	MyPerk = GetPerk();
	if( MyPerk != None )
	{
		Rate *= MyPerk.GetReloadRateScale( self );
	}

	return Rate;
}

defaultproperties
{
	MagazineCapacity(0)=2 //50% increase (round up)
	SpareAmmoCapacity(0)=41 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=438.0 //25% increase (round up)
   	InstantHitDamage(BASH_FIREMODE)=33 //25% increase (round up)
   Name="Default__WMWeap_Bow_Crossbow_Precious"
}