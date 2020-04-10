class WMWeap_Pistol_AF2011_Precious extends KFWeap_Pistol_AF2011;



const VARIANT_SKIN_ID = 5955;



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

	Rate = 0.91f;

	MyPerk = GetPerk();
	if( MyPerk != None )
	{
		Rate *= MyPerk.GetReloadRateScale( self );
	}

	return Rate;
}




defaultproperties
{
   DualClass=Class'ZedternalReborn.WMWeap_Pistol_DualAF2011_Precious'
   InstantHitDamage(0)=70.000000
   MagazineCapacity(0)=20
   Name="Default__WMWeap_Pistol_AF2011_Precious"
}
