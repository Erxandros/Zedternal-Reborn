class WMWeap_Blunt_MaceAndShield_Precious extends KFWeap_Blunt_MaceAndShield;



const VARIANT_SKIN_ID = 4560;



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
   InstantHitDamage(0)=105.000000
   InstantHitDamage(3)=230.000000
   InstantHitDamage(5)=216.000000
   Name="Default__WMWeap_Blunt_MaceAndShield_Precious"
}
