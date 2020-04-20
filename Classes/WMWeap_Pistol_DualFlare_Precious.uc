class WMWeap_Pistol_DualFlare_Precious extends KFWeap_Pistol_DualFlare;

const VARIANT_SKIN_ID = 4803;

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

	Rate = 0.8f;

	MyPerk = GetPerk();
	if( MyPerk != None )
	{
		Rate *= MyPerk.GetReloadRateScale( self );
	}

	return Rate;
}

defaultproperties
{
	SingleClass=Class'ZedternalReborn.WMWeap_Pistol_Flare_Precious'
	MagazineCapacity(0)=18 //50% increase
	SpareAmmoCapacity(0)=216 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=50.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	Name="Default__WMWeap_Pistol_DualFlare_Precious"
}