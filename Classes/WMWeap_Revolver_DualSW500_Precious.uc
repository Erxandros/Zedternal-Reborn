class WMWeap_Revolver_DualSW500_Precious extends KFWeap_Revolver_DualSW500;

const VARIANT_SKIN_ID = 3439;

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
	SingleClass=Class'ZedternalReborn.WMWeap_Revolver_SW500_Precious'
	MagazineCapacity(0)=16 //50% increase (round up)
	SpareAmmoCapacity(0)=114 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=200.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=200.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	Name="Default__WMWeap_Revolver_DualSW500_Precious"
}