class WMWeap_GrenadeLauncher_M79_Precious extends KFWeap_GrenadeLauncher_M79;



const VARIANT_SKIN_ID = 3432;



reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	Super.ClientWeaponSet(bOptionalSet, bDoNotActivate);
	class'ZedternalReborn.WMWeaponPrecious_Helper'.static.VariantClientWeaponSet( self, VARIANT_SKIN_ID );
}
function SetOriginalValuesFromPickup( KFWeapon PickedUpWeapon )
{
	class'ZedternalReborn.WMWeaponPrecious_Helper'.static.VariantSetOriginalValuesFromPickup( self, PickedUpWeapon, VARIANT_SKIN_ID );
}






/** Returns an anim rate scale for reloading */
simulated function float GetReloadRateScale()
{
	local float Rate;
	local KFPerk MyPerk;

	Rate = 0.75f;

	MyPerk = GetPerk();
	if( MyPerk != None )
	{
		Rate *= MyPerk.GetReloadRateScale( self );
	}

	return Rate;
}




defaultproperties
{
   WeaponProjectiles(0)=Class'ZedternalReborn.WMProj_HighExplosive_M79_Precious'
   InstantHitDamage(0)=250.000000
   Name="Default__WMWeap_GrenadeLauncher_M79_Precious"
}
