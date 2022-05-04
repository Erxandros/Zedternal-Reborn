class WMWeap_Shotgun_DoubleBarrel_Precious extends KFWeap_Shotgun_DoubleBarrel;

defaultproperties
{
	MagazineCapacity(0)=4
	AmmoPickupScale(0)=1.5
	SpareAmmoCapacity(0)=65
	InstantHitDamage(ALTFIRE_FIREMODE)=34
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=34
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_DoubleBarrel_Precious"
}
