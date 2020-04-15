class WMWeap_AssaultRifle_AK12_Precious extends KFWeap_AssaultRifle_AK12;



const VARIANT_SKIN_ID = 3459;



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
   InstantHitDamage(0)=52.000000
   InstantHitDamage(1)=52.000000
   MagazineCapacity(0)=45
   Name="Default__WMWeap_AssaultRifle_AK12_Precious"
}
