class WMWeap_RocketLauncher_Seeker6_Precious extends KFWeap_RocketLauncher_Seeker6;

defaultproperties
{
	WeaponProjectiles(0)=Class'ZedternalReborn.WMProj_Rocket_Seeker6_Precious'
	MagazineCapacity(0)=9 //50% increase
	SpareAmmoCapacity(0)=101 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=150.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=150.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=37.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_RocketLauncher_Seeker6_Precious"
}
