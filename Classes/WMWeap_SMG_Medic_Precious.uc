class WMWeap_SMG_Medic_Precious extends KFWeap_SMG_Medic;

const VARIANT_SKIN_ID = 3448;

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
	SpareAmmoCapacity(0)=576 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=25.0 //25% increase
	AmmoCost(ALTFIRE_FIREMODE)=32 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=29.0 //25% increase (round up)
	Name="Default__WMWeap_SMG_Medic_Precious"
}