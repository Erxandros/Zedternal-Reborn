class WMWeap_LMG_Stoner63A_Precious extends KFWeap_LMG_Stoner63A;

const VARIANT_SKIN_ID = 5141;

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
	MagazineCapacity(0)=113 //50% increase (round up)
	SpareAmmoCapacity(0)=600 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=38.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	Name="Default__WMWeap_LMG_Stoner63A_Precious"
}