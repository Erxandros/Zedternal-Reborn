class WMWeap_Edged_Zweihander_Precious extends KFWeap_Edged_Zweihander;

const VARIANT_SKIN_ID = 5920;

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
	InstantHitMomentum(DEFAULT_FIREMODE)=37500.f //25% increase
	InstantHitDamage(DEFAULT_FIREMODE)=107.0 //25% increase (round up)
	InstantHitMomentum(HEAVY_ATK_FIREMODE)=37500.f //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=244.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=79.0 //25% increase (round up)
	Name="Default__WMWeap_Edged_Zweihander_Precious"
}