class WMWeap_GrenadeLauncher_HX25_Precious extends KFWeap_GrenadeLauncher_HX25;

defaultproperties
{
	MagazineCapacity(0)=2
	AmmoPickupScale(0)=1.5
	SpareAmmoCapacity(0)=35
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=13
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_ExplosiveSubMunition_HX25_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_GrenadeLauncher_HX25_Precious"
}
