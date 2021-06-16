class WMWeap_RocketLauncher_ThermiteBore_Precious extends KFWeap_RocketLauncher_ThermiteBore;

defaultproperties
{
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=44 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Rocket_ThermiteBore_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=188.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_RocketLauncher_ThermiteBore_Precious"
}
