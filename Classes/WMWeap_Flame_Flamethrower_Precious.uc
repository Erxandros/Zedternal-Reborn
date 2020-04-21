class WMWeap_Flame_Flamethrower_Precious extends KFWeap_Flame_Flamethrower;

const VARIANT_SKIN_ID = 3434;

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
	MagazineCapacity(0)=150 //50% increase
	SpareAmmoCapacity(0)=600 //20% increase
	FireInterval(DEFAULT_FIREMODE)=0.056 //25% increase
   	InstantHitDamage(BASH_FIREMODE)=35 //25% increase
	Name="Default__WMWeap_Flame_Flamethrower_Precious"
}