class WMWeap_Rifle_Winchester1894_Precious extends KFWeap_Rifle_Winchester1894;

defaultproperties
{
	MagazineCapacity(0)=18
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=101
	InstantHitDamage(BASH_FIREMODE)=32
	InstantHitDamage(DEFAULT_FIREMODE)=100
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Winchester1894_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_Winchester1894_Precious"
}
