class WMWeap_Eviscerator_Precious extends KFWeap_Eviscerator;

const VARIANT_SKIN_ID = 3431;

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
	MagazineCapacity(0)=8 //50% increase (round up)
	SpareAmmoCapacity(0)=30 //20% increase
	MagazineCapacity(1)=375 //50% increase
	InstantHitDamage(DEFAULT_FIREMODE)=375.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=37.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=113.0 //25% increase (round up)
	Name="Default__WMWeap_Eviscerator_Precious"
}