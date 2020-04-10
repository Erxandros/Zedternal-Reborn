class WMWeap_Shotgun_AA12_Precious extends KFWeap_Shotgun_AA12;



const VARIANT_SKIN_ID = 3425;



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
   MagazineCapacity(0)=28
   SpareAmmoCapacity(0)=150
   Name="Default__WMWeap_Shotgun_AA12_Precious"
}
