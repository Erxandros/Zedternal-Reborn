class WMWeap_Shotgun_AA12_Precious extends KFWeap_Shotgun_AA12;

const VARIANT_SKIN_ID = 3425;

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
	SpareAmmoCapacity(0)=144 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=25.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=25.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=38.0 //25% increase (round up)
	Name="Default__WMWeap_Shotgun_AA12_Precious"
}