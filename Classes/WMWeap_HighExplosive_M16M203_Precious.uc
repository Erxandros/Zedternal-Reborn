class WMWeap_HighExplosive_M16M203_Precious extends KFWeap_AssaultRifle_M16M203;



const VARIANT_SKIN_ID = 4984;



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
   MagazineCapacity(0)=45
   InstantHitDamage(0)=37.000000
   WeaponProjectiles(1)=Class'ZedternalReborn.WMProj_HighExplosive_M16M203_Precious'
   Name="Default__WMWeap_HighExplosive_M16M203_Precious"
}
