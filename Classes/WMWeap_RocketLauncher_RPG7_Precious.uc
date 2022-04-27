class WMWeap_RocketLauncher_RPG7_Precious extends KFWeap_RocketLauncher_RPG7;

defaultproperties
{
	MagazineCapacity(0)=2
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=18
	InstantHitDamage(BASH_FIREMODE)=37
	InstantHitDamage(DEFAULT_FIREMODE)=188
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Rocket_RPG7_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_RocketLauncher_RPG7_Precious"
}
