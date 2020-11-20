class WMWeap_RocketLauncher_SealSqueal_Precious extends KFWeap_RocketLauncher_SealSqueal;

defaultproperties
{
	MagazineCapacity(0)=8 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=36 //20% increase
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Rocket_SealSqueal_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=157.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_RocketLauncher_SealSqueal_Precious"
}
