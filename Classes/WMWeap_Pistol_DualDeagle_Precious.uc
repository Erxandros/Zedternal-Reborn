class WMWeap_Pistol_DualDeagle_Precious extends KFWeap_Pistol_DualDeagle;

const VARIANT_SKIN_ID = 3437;

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
	SingleClass=Class'ZedternalReborn.WMWeap_Pistol_Deagle_Precious'
	MagazineCapacity(0)=22 //50% increase (round up)
	SpareAmmoCapacity(0)=118 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=114.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=114.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30 //25% increase
	Name="Default__WMWeap_Pistol_DualDeagle_Precious"
}