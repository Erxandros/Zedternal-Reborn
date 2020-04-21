class WMWeap_Rifle_Hemogoblin_Precious extends KFWeap_Rifle_Hemogoblin;

const VARIANT_SKIN_ID = 5953;

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
	MagazineCapacity(0)=11 //50% increase (round up)
	SpareAmmoCapacity(0)=118 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=125.0 //25% increase
	AmmoCost(ALTFIRE_FIREMODE)=24 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=34.0 //25% increase (round up)
	Name="Default__WMWeap_Rifle_Hemogoblin_Precious"
}