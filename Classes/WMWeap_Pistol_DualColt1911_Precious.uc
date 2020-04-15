class WMWeap_Pistol_DualColt1911_Precious extends KFWeap_Pistol_DualColt1911;



const VARIANT_SKIN_ID = 3438;



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

	Rate = 0.89f;

	MyPerk = GetPerk();
	if( MyPerk != None )
	{
		Rate *= MyPerk.GetReloadRateScale( self );
	}

	return Rate;
}




defaultproperties
{
   SingleClass=Class'Zedternal.WMWeap_Pistol_Colt1911_Precious'
   MagazineCapacity(0)=22
   InstantHitDamage(0)=115.000000
   InstantHitDamage(1)=115.000000
   Name="Default__WMWeap_Pistol_DualColt1911_Precious"
}
