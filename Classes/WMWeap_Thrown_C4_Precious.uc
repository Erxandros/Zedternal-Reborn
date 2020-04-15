class WMWeap_Thrown_C4_Precious extends KFWeap_Thrown_C4;



const VARIANT_SKIN_ID = 3463;



reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	Super.ClientWeaponSet(bOptionalSet, bDoNotActivate);
	class'Zedternal.WMWeaponPrecious_Helper'.static.VariantClientWeaponSet( self, VARIANT_SKIN_ID );
}
function SetOriginalValuesFromPickup( KFWeapon PickedUpWeapon )
{
	class'Zedternal.WMWeaponPrecious_Helper'.static.VariantSetOriginalValuesFromPickup( self, PickedUpWeapon, VARIANT_SKIN_ID );
}











defaultproperties
{
   SpareAmmoCapacity(0)=4
   InitialSpareMags(0)=4
   WeaponProjectiles(0)=Class'Zedternal.WMProj_Thrown_C4_Precious'
   InstantHitDamage(3)=30.000000
   Name="Default__WMWeap_Thrown_C4_Precious"
}
