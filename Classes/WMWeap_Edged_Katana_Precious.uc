class WMWeap_Edged_Katana_Precious extends KFWeap_Edged_Katana;

const VARIANT_SKIN_ID = 5054;

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
	InstantHitDamage(DEFAULT_FIREMODE)=85.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=113.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=85.0 //25% increase
	Name="Default__WMWeap_Edged_Katana_Precious"
}