class WMWeap_Shotgun_HZ12_Precious extends KFWeap_Shotgun_HZ12;

const VARIANT_SKIN_ID = 5140;

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
	MagazineCapacity(0)=24 //50% increase
	SpareAmmoCapacity(0)=96 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=25.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	Name="Default__WMWeap_Shotgun_HZ12_Precious"
}