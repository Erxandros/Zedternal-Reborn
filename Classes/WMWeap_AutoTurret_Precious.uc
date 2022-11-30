class WMWeap_AutoTurret_Precious extends WMWeap_AutoTurret;

defaultproperties
{
	TurretPawn=class'ZedternalReborn.WMPawn_AutoTurret_Precious';
	TurretWeapon=class'ZedternalReborn.WMWeap_AutoTurretWeapon_Precious';

	MaxTurretsDeployedZedternal=3

	SpareAmmoCapacity(0)=8
	InstantHitDamage(BASH_FIREMODE)=36
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AutoTurret_Precious"
}
