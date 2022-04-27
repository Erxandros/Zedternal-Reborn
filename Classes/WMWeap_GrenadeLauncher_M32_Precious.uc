class WMWeap_GrenadeLauncher_M32_Precious extends KFWeap_GrenadeLauncher_M32;

defaultproperties
{
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=44
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=188
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_HighExplosive_M32_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_GrenadeLauncher_M32_Precious"
}
