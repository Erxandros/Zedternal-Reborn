class WMWeap_Shotgun_Medic_Precious extends KFWeap_Shotgun_Medic;



const VARIANT_SKIN_ID = 3450;



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
   HealFullRechargeSeconds=10.000000
   InstantHitDamage(0)=27.000000
   Name="Default__WMWeap_Shotgun_Medic_Precious"
}
