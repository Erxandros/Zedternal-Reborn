class WMWeap_Shotgun_DragonsBreath_Precious extends KFWeap_Shotgun_DragonsBreath;

const VARIANT_SKIN_ID = 3436;

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
	MagazineCapacity(0)=9 //50% increase
	SpareAmmoCapacity(0)=72 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=44.00 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	Name="Default__WMWeap_Shotgun_DragonsBreath_Precious"
}