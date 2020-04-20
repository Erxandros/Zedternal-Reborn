class WMWeap_Shotgun_Medic_Precious extends KFWeap_Shotgun_Medic;

const VARIANT_SKIN_ID = 3450;

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
	SpareAmmoCapacity(0)=108 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=32.0 //25% increase (round up)
	AmmoCost(ALTFIRE_FIREMODE)=32 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	Name="Default__WMWeap_Shotgun_Medic_Precious"
}