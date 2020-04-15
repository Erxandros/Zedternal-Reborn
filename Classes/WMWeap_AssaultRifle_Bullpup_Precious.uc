class WMWeap_AssaultRifle_Bullpup_Precious extends KFWeap_AssaultRifle_Bullpup;



const VARIANT_SKIN_ID = 3427;



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
   InstantHitDamage(0)=49.000000
   InstantHitDamage(1)=49.000000
   SpareAmmoCapacity(0)=360
   InitialSpareMags(0)=5
   Name="Default__WMWeap_AssaultRifle_Bullpup_Precious"
}
