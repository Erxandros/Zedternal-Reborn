class WMWeap_AssaultRifle_SCAR_Precious extends KFWeap_AssaultRifle_SCAR;

const VARIANT_SKIN_ID = 3428;

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
	MagazineCapacity(0)=30 //50% increase
	SpareAmmoCapacity(0)=408 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=69.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=69.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	Name="Default__WMWeap_AssaultRifle_SCAR_Precious"
}
