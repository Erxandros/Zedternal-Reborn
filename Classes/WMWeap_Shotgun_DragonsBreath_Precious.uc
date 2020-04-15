class WMWeap_Shotgun_DragonsBreath_Precious extends KFWeap_Shotgun_DragonsBreath;



const VARIANT_SKIN_ID = 3436;



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
   PenetrationPower(0)=3.000000
   InstantHitDamage(0)=40.000000
   Name="Default__WMWeap_Shotgun_DragonsBreath_Precious"
}
