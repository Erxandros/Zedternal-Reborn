class WMWeap_RocketLauncher_RPG7_Precious extends KFWeap_RocketLauncher_RPG7;

defaultproperties
{
	MagazineCapacity(0)=2 //50% increase (round up)
	AmmoPickupScale(0)=1.0 //50% decrease
	SpareAmmoCapacity(0)=18 //20% increase
	WeaponProjectiles(DEFAULT_FIREMODE)=Class'ZedternalReborn.WMProj_Rocket_RPG7_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=188.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=37.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_RocketLauncher_RPG7_Precious"
}
