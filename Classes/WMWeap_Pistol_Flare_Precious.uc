class WMWeap_Pistol_Flare_Precious extends KFWeap_Pistol_Flare;

const VARIANT_SKIN_ID = 4803;

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
	DualClass=Class'ZedternalReborn.WMWeap_Pistol_DualFlare_Precious'
	MagazineCapacity(0)=9 //50% increase
	SpareAmmoCapacity(0)=224 //25% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=28.0 //25% increase (round up)
	Name="Default__WMWeap_Pistol_Flare_Precious"
}