class WMWeap_AssaultRifle_SCAR_Precious extends KFWeap_AssaultRifle_SCAR;



const VARIANT_SKIN_ID = 3428;



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
   InstantHitDamage(0)=75.000000
   InstantHitDamage(1)=75.000000
   Name="Default__WMWeap_AssaultRifle_SCAR_Precious"
}
