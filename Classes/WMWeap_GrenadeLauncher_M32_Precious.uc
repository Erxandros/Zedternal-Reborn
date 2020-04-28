class WMWeap_GrenadeLauncher_M32_Precious extends KFWeap_GrenadeLauncher_M32;

defaultproperties
{
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=44 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=Class'ZedternalReborn.WMProj_HighExplosive_M32_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=188.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_GrenadeLauncher_M32_Precious"
}
