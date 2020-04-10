class WMWeap_HuskCannon_Precious extends KFWeap_HuskCannon;



const VARIANT_SKIN_ID = 5952;



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
   MaxChargeTime=0.750000
   ValueIncreaseTime=0.150000
   DmgIncreasePerCharge=0.800000
   Name="Default__WMWeap_HuskCannon_Precious"
}
