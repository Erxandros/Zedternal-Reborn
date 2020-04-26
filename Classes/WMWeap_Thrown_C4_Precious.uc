class WMWeap_Thrown_C4_Precious extends KFWeap_Thrown_C4;

const VARIANT_SKIN_ID = 3463;

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
	WeaponProjectiles(THROW_FIREMODE)=Class'ZedternalReborn.WMProj_Thrown_C4_Precious'
	SpareAmmoCapacity(0)=4 //double spare ammo
	InstantHitDamage(BASH_FIREMODE)=29.0 //25% increase (round up)
	Name="Default__WMWeap_Thrown_C4_Precious"
}