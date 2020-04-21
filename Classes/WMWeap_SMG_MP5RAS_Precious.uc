class WMWeap_SMG_MP5RAS_Precious extends KFWeap_SMG_MP5RAS;

const VARIANT_SKIN_ID = 4787;

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
	MagazineCapacity(0)=60 //50% increase (round up)
	SpareAmmoCapacity(0)=384 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=32.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=32.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	Name="Default__WMWeap_SMG_MP5RAS_Precious"
}