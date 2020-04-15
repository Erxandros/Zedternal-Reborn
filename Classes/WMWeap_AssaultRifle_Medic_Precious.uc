class WMWeap_AssaultRifle_Medic_Precious extends KFWeap_AssaultRifle_Medic;



const VARIANT_SKIN_ID = 3467;



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
   RecoilRate=0.070000
   InstantHitDamage(0)=42.000000
   Name="Default__WMWeap_AssaultRifle_Medic_Precious"
}
