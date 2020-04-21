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

defaultproperties
{
	MagazineCapacity(0)=75 //50% increase
	SpareAmmoCapacity(0)=600 //20% increase
	FireInterval(DEFAULT_FIREMODE)=0.056 //25% increase
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	Name="Default__WMWeap_Flame_CaulkBurn_Precious"
}