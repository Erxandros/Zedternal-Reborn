class WMWeap_AssaultRifle_AR15_Precious extends KFWeap_AssaultRifle_AR15;

defaultproperties
{
	MagazineCapacity(0)=30
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=288
	InstantHitDamage(ALTFIRE_FIREMODE)=38
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol9mm_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=38
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol9mm_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_AR15_Precious"
}
