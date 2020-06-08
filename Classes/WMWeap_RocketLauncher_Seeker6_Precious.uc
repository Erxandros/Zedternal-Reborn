class WMWeap_RocketLauncher_Seeker6_Precious extends KFWeap_RocketLauncher_Seeker6;

defaultproperties
{
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=1.0 //50% decrease
	SpareAmmoCapacity(0)=101 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=Class'ZedternalReborn.WMProj_Rocket_Seeker6_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=157.0 //25% increase (round up)
	WeaponProjectiles(ALTFIRE_FIREMODE)=Class'ZedternalReborn.WMProj_Rocket_Seeker6_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=157.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=37.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_RocketLauncher_Seeker6_Precious"
}
