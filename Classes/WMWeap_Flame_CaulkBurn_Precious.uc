class WMWeap_Flame_CaulkBurn_Precious extends KFWeap_Flame_CaulkBurn;



const VARIANT_SKIN_ID = 3290;



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

	Rate = 0.7f;

	MyPerk = GetPerk();
	if( MyPerk != None )
	{
		Rate *= MyPerk.GetReloadRateScale( self );
	}

	return Rate;
}




defaultproperties
{
   MagazineCapacity(0)=100
   SpareAmmoCapacity(0)=1000
   InitialSpareMags(0)=5
   AmmoPickupScale(0)=1.000000
   FireInterval(0)=0.020000
   Name="Default__WMWeap_Flame_CaulkBurn_Precious"
}
