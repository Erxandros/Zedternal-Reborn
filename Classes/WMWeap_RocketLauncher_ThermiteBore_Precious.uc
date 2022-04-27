class WMWeap_RocketLauncher_ThermiteBore_Precious extends KFWeap_RocketLauncher_ThermiteBore;

defaultproperties
{
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=44
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=188
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Rocket_ThermiteBore_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_RocketLauncher_ThermiteBore_Precious"
}
