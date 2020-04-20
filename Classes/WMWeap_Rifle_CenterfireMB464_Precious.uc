class WMWeap_Rifle_CenterfireMB464_Precious extends KFWeap_Rifle_CenterfireMB464;

const VARIANT_SKIN_ID = 6220;

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
	MagazineCapacity(0)=15 //50% increase
	SpareAmmoCapacity(0)=84 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=207.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	Name="Default__WMWeap_Rifle_CenterfireMB464_Precious"
}