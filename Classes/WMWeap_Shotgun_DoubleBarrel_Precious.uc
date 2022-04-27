class WMWeap_Shotgun_DoubleBarrel_Precious extends KFWeap_Shotgun_DoubleBarrel;

defaultproperties
{
	MagazineCapacity(0)=3
	AmmoPickupScale(0)=1.5
	SpareAmmoCapacity(0)=56
	InstantHitDamage(ALTFIRE_FIREMODE)=32
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=32
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_DoubleBarrel_Precious"
}
