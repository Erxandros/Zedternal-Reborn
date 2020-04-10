class WMWeap_SMG_Medic_Precious extends KFWeap_SMG_Medic;



const VARIANT_SKIN_ID = 3448;



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
   MagazineCapacity(0)=50
   InstantHitDamage(0)=33.000000
   Name="Default__WMWeap_SMG_Medic_Precious"
}
