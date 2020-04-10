class WMWeap_SMG_Mac10_Precious extends KFWeap_SMG_Mac10;



const VARIANT_SKIN_ID = 5956;



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
   InstantHitDamage(0)=32.000000
   InstantHitDamage(1)=32.000000
   MagazineCapacity(0)=40
   Name="Default__WMWeap_SMG_Mac10_Precious"
}
