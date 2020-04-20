class WMWeap_Shotgun_Nailgun_Precious extends WMWeap_Shotgun_Nailgun;

const VARIANT_SKIN_ID = 3429;

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
	MagazineCapacity(0)=63 //50% increase
	SpareAmmoCapacity(0)=404 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=44.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=44.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	Name="Default__WMWeap_Shotgun_Nailgun_Precious"
}