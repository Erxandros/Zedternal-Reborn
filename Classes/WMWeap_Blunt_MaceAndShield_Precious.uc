class WMWeap_Blunt_MaceAndShield_Precious extends KFWeap_Blunt_MaceAndShield;

const VARIANT_SKIN_ID = 4560;

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
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=219.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=207.0 //25% increase (round up)
	Name="Default__WMWeap_Blunt_MaceAndShield_Precious"
}