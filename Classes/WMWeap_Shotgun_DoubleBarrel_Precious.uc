class WMWeap_Shotgun_DoubleBarrel_Precious extends KFWeap_Shotgun_DoubleBarrel;



const VARIANT_SKIN_ID = 3423;



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

	Rate = 0.90f;

	MyPerk = GetPerk();
	if( MyPerk != None )
	{
		Rate *= MyPerk.GetReloadRateScale( self );
	}

	return Rate;
}




defaultproperties
{
   InstantHitDamage(0)=33.000000
   InstantHitDamage(1)=33.000000
   Name="Default__WMWeap_Shotgun_DoubleBarrel_Precious"
}
