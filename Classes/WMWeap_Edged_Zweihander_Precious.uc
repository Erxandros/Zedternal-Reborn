class WMWeap_Edged_Zweihander_Precious extends KFWeap_Edged_Zweihander;



const VARIANT_SKIN_ID = 5920;



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
   InstantHitDamage(0)=125.000000
   InstantHitDamage(3)=85.000000
   InstantHitDamage(5)=275.000000
   InstantHitMomentum(0)=35000.000000
   InstantHitMomentum(5)=35000.000000
   Name="Default__WMWeap_Edged_Zweihander_Precious"
}
