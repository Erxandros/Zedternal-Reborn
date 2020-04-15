class WMWeap_SMG_P90_Precious extends KFWeap_SMG_P90;



const VARIANT_SKIN_ID = 4789;



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
   InstantHitDamage(0)=35.000000
   InstantHitDamage(1)=35.000000
   MagazineCapacity(0)=65
   Name="Default__WMWeap_SMG_P90_Precious"
}
