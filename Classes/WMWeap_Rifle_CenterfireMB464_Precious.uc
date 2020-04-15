class WMWeap_Rifle_CenterfireMB464_Precious extends KFWeap_Rifle_CenterfireMB464;



const VARIANT_SKIN_ID = 6220;



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
   MagazineCapacity(0)=10
   FireInterval(0)=0.300000
   InstantHitDamage(0)=350.000000
   Name="Default__WMWeap_Rifle_CenterfireMB464_Precious"
}
