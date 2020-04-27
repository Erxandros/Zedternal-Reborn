class WMWeap_GrenadeLauncher_M79_Precious extends KFWeap_GrenadeLauncher_M79;

defaultproperties
{
	WeaponProjectiles(0)=Class'ZedternalReborn.WMProj_HighExplosive_M79_Precious'
	MagazineCapacity(0)=2 //50% increase (round up)
	SpareAmmoCapacity(0)=32 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=188.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_GrenadeLauncher_M79_Precious"
}
