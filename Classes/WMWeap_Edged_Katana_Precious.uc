class WMWeap_Edged_Katana_Precious extends KFWeap_Edged_Katana;



const VARIANT_SKIN_ID = 5054;



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
   InstantHitDamage(0)=150.000000
   InstantHitDamage(3)=150.000000
   InstantHitDamage(5)=200.000000
   Name="Default__WMWeap_Edged_Katana_Precious"
}
