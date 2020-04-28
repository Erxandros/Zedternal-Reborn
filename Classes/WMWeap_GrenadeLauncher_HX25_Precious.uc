class WMWeap_GrenadeLauncher_HX25_Precious extends KFWeap_GrenadeLauncher_HX25;

defaultproperties
{
	MagazineCapacity(0)=2 //50% increase (round up)
	AmmoPickupScale(0)=1.5 //50% decrease
	SpareAmmoCapacity(0)=35 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=Class'ZedternalReborn.WMProj_ExplosiveSubmunition_HX25_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=13.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_GrenadeLauncher_HX25_Precious"
}
