class WMWeap_SMG_HK_UMP_Precious extends KFWeap_SMG_HK_UMP;

const VARIANT_SKIN_ID = 5951;

reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	Super.ClientWeaponSet(bOptionalSet, bDoNotActivate);
	class'ZedternalReborn.WMWeaponPrecious_Helper'.static.VariantClientWeaponSet( self, VARIANT_SKIN_ID );
}

function SetOriginalValuesFromPickup( KFWeapon PickedUpWeapon )
{
	class'ZedternalReborn.WMWeaponPrecious_Helper'.static.VariantSetOriginalValuesFromPickup( self, PickedUpWeapon, VARIANT_SKIN_ID );
}

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	SpareAmmoCapacity(0)=348 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=57.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=57.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	Name="Default__WMWeap_SMG_HK_UMP_Precious"
}