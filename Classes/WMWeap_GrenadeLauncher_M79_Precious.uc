class WMWeap_GrenadeLauncher_M79_Precious extends KFWeap_GrenadeLauncher_M79;

const VARIANT_SKIN_ID = 3432;

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
	WeaponProjectiles(0)=Class'ZedternalReborn.WMProj_HighExplosive_M79_Precious'
	MagazineCapacity(0)=2 //50% increase (round up)
	SpareAmmoCapacity(0)=32 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=188.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	Name="Default__WMWeap_GrenadeLauncher_M79_Precious"
}