class WMWeap_HRG_Warthog_Precious extends WMWeap_HRG_Warthog;

defaultproperties
{
	TurretPawn=class'ZedternalReborn.WMPawn_HRG_Warthog_Precious';
	TurretWeapon=class'ZedternalReborn.WMWeap_HRG_WarthogWeapon_Precious';

	MaxTurretsDeployedZedternal=3

	SpareAmmoCapacity(0)=8
	InstantHitDamage(BASH_FIREMODE)=36
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Warthog_Precious"
}
