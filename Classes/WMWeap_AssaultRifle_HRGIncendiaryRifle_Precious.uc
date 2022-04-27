class WMWeap_AssaultRifle_HRGIncendiaryRifle_Precious extends WMWeap_AssaultRifle_HRGIncendiaryRifle;

defaultproperties
{
	MagazineCapacity(0)=45
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=324
	MagazineCapacity(1)=2
	AmmoPickupScale(1)=1
	SpareAmmoCapacity(1)=11
	InstantHitDamage(ALTFIRE_FIREMODE)=288
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Grenade_HRGIncendiaryRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=38
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRGIncendiaryRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_HRGIncendiaryRifle_Precious"
}
