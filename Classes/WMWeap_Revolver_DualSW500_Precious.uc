class WMWeap_Revolver_DualSW500_Precious extends KFWeap_Revolver_DualSW500;



const VARIANT_SKIN_ID = 3439;



reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	Super.ClientWeaponSet(bOptionalSet, bDoNotActivate);
	class'Zedternal.WMWeaponPrecious_Helper'.static.VariantClientWeaponSet( self, VARIANT_SKIN_ID );
}
function SetOriginalValuesFromPickup( KFWeapon PickedUpWeapon )
{
	class'Zedternal.WMWeaponPrecious_Helper'.static.VariantSetOriginalValuesFromPickup( self, PickedUpWeapon, VARIANT_SKIN_ID );
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
   SingleClass=Class'Zedternal.WMWeap_Revolver_SW500_Precious'
   FireInterval(0)=0.140000
   FireInterval(1)=0.140000
   InstantHitDamage(0)=215.000000
   InstantHitDamage(1)=215.000000
   Name="Default__WMWeap_Revolver_DualSW500_Precious"
}
