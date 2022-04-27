class WMWeap_Shotgun_AA12_Precious extends KFWeap_Shotgun_AA12;

defaultproperties
{
	MagazineCapacity(0)=30
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=144
	InstantHitDamage(ALTFIRE_FIREMODE)=25
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	InstantHitDamage(BASH_FIREMODE)=38
	InstantHitDamage(DEFAULT_FIREMODE)=25
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_AA12_Precious"
}
