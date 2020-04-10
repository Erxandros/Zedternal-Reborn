class WMWeap_RocketLauncher_Seeker6_Precious extends KFWeap_RocketLauncher_Seeker6;



const VARIANT_SKIN_ID = 5954;



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
   WeaponProjectiles(0)=Class'ZedternalReborn.WMProj_Rocket_Seeker6_Precious'
   Name="Default__WMWeap_RocketLauncher_Seeker6_Precious"
}
