class WMWeap_Rifle_M14EBR_Precious extends KFWeap_Rifle_M14EBR;



const VARIANT_SKIN_ID = 4793;



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
   MagazineCapacity(0)=25
   FireInterval(0)=0.158000
   InstantHitDamage(0)=130.000000
   Name="Default__WMWeap_Rifle_M14EBR_Precious"
}
