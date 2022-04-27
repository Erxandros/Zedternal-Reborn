class WMWeap_RocketLauncher_SealSqueal_Precious extends KFWeap_RocketLauncher_SealSqueal;

defaultproperties
{
	MagazineCapacity(0)=8
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=36
	InstantHitDamage(BASH_FIREMODE)=32
	InstantHitDamage(DEFAULT_FIREMODE)=157
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Rocket_SealSqueal_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_RocketLauncher_SealSqueal_Precious"
}
