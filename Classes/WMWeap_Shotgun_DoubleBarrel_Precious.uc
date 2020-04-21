class WMWeap_Shotgun_DoubleBarrel_Precious extends KFWeap_Shotgun_DoubleBarrel;

const VARIANT_SKIN_ID = 3423;

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
	MagazineCapacity(0)=3 //50% increase
	SpareAmmoCapacity(0)=56 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=32.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=32.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	Name="Default__WMWeap_Shotgun_DoubleBarrel_Precious"
}