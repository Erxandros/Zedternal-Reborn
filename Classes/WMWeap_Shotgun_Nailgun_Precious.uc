class WMWeap_Shotgun_Nailgun_Precious extends WMWeap_Shotgun_Nailgun;



const VARIANT_SKIN_ID = 3429;



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
   InstantHitDamage(0)=37.000000
   InstantHitDamage(1)=37.000000
   FireInterval(0)=0.340000
   FireInterval(1)=0.340000
   Name="Default__WMWeap_Shotgun_Nailgun_Precious"
}
