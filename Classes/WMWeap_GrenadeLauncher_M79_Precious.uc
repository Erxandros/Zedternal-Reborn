class WMWeap_GrenadeLauncher_M79_Precious extends KFWeap_GrenadeLauncher_M79;

defaultproperties
{
	MagazineCapacity(0)=2 //50% increase (round up)
	AmmoPickupScale(0)=1.0 //50% decrease
	SpareAmmoCapacity(0)=32 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=Class'ZedternalReborn.WMProj_HighExplosive_M79_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=188.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_GrenadeLauncher_M79_Precious"
}
