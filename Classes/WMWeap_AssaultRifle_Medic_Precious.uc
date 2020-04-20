class WMWeap_AssaultRifle_Medic_Precious extends KFWeap_AssaultRifle_Medic;

const VARIANT_SKIN_ID = 3467;

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
	MagazineCapacity(0)=60 //50% increase
	SpareAmmoCapacity(0)=480 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=44.0 //25% increase (round up)
	AmmoCost(ALTFIRE_FIREMODE)=30 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=34.0 //25% increase (round up)
	Name="Default__WMWeap_AssaultRifle_Medic_Precious"
}