class WMWeap_GrenadeLauncher_HX25_Precious extends KFWeap_GrenadeLauncher_HX25;

defaultproperties
{
	MagazineCapacity(0)=2
	AmmoPickupScale(0)=1.5
	SpareAmmoCapacity(0)=41
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=14
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_ExplosiveSubMunition_HX25_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_GrenadeLauncher_HX25_Precious"
}
