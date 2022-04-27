class WMWeap_GrenadeLauncher_M79_Precious extends KFWeap_GrenadeLauncher_M79;

defaultproperties
{
	MagazineCapacity(0)=2
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=32
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=188
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_HighExplosive_M79_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_GrenadeLauncher_M79_Precious"
}
