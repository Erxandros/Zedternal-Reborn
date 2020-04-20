class WMWeap_Rifle_M14EBR_Precious extends KFWeap_Rifle_M14EBR;

const VARIANT_SKIN_ID = 4793;

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
	SpareAmmoCapacity(0)=144 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=34.0 //25% increase (round up)
	Name="Default__WMWeap_Rifle_M14EBR_Precious"
}