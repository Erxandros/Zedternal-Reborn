class WMWeap_HuskCannon_Precious extends KFWeap_HuskCannon;

const VARIANT_SKIN_ID = 5952;

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
	SpareAmmoCapacity(0)=180 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=35.0 //25% increase
	MaxChargeTime=0.800000 //20% decrease
	Name="Default__WMWeap_HuskCannon_Precious"
}