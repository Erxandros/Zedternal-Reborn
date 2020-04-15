class WMWeap_SMG_HK_UMP_Precious extends KFWeap_SMG_HK_UMP;



const VARIANT_SKIN_ID = 5951;



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
   InstantHitDamage(0)=51.000000
   InstantHitDamage(1)=51.000000
   MagazineCapacity(0)=45
   Name="Default__WMWeap_SMG_HK_UMP_Precious"
}
