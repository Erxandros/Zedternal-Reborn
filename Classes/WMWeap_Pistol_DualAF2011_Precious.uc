class WMWeap_Pistol_DualAF2011_Precious extends KFWeap_Pistol_DualAF2011;

const VARIANT_SKIN_ID = 5955;

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

	Rate = 0.91f;

	MyPerk = GetPerk();
	if( MyPerk != None )
	{
		Rate *= MyPerk.GetReloadRateScale( self );
	}

	return Rate;
}

defaultproperties
{
	SingleClass=Class'ZedternalReborn.WMWeap_Pistol_AF2011_Precious'
	MagazineCapacity(0)=48 //50% increase
	SpareAmmoCapacity(0)=327 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=67.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=67.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30 //25% increase
	Name="Default__WMWeap_Pistol_DualAF2011_Precious"
}