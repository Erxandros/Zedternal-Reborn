class WMWeap_Pistol_DualColt1911_Precious extends KFWeap_Pistol_DualColt1911;

const VARIANT_SKIN_ID = 3438;

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
   SingleClass=Class'ZedternalReborn.WMWeap_Pistol_Colt1911_Precious'
	MagazineCapacity(0)=24 //50% increase
	SpareAmmoCapacity(0)=154 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
   Name="Default__WMWeap_Pistol_DualColt1911_Precious"
}