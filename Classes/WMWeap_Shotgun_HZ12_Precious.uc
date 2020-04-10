class WMWeap_Shotgun_HZ12_Precious extends KFWeap_Shotgun_HZ12;



const VARIANT_SKIN_ID = 5140;



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
   PumpFireInterval=0.490000
   InstantHitDamage(0)=23.000000
   Name="Default__WMWeap_Shotgun_HZ12_Precious"
}
