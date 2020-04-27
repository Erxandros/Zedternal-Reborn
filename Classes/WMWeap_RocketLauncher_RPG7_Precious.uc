class WMWeap_RocketLauncher_RPG7_Precious extends KFWeap_RocketLauncher_RPG7;

defaultproperties
{
	WeaponProjectiles(0)=Class'ZedternalReborn.WMProj_Rocket_RPG7_Precious'
	MagazineCapacity(0)=2 //50% increase (round up)
	SpareAmmoCapacity(0)=18 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=188.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=37.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_RocketLauncher_RPG7_Precious"
}
