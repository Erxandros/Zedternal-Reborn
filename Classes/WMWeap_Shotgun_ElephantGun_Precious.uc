class WMWeap_Shotgun_ElephantGun_Precious extends KFWeap_Shotgun_ElephantGun;

defaultproperties
{
	MagazineCapacity(0)=6
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=58
	InstantHitDamage(ALTFIRE_FIREMODE)=50
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	InstantHitDamage(BASH_FIREMODE)=34
	InstantHitDamage(DEFAULT_FIREMODE)=50
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_ElephantGun_Precious"
}
