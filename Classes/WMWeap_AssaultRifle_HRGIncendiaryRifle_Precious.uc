class WMWeap_AssaultRifle_HRGIncendiaryRifle_Precious extends WMWeap_AssaultRifle_HRGIncendiaryRifle;

defaultproperties
{
	MagazineCapacity(0)=60
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=378
	MagazineCapacity(1)=2
	AmmoPickupScale(1)=1
	SpareAmmoCapacity(1)=13
	InstantHitDamage(ALTFIRE_FIREMODE)=311
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Grenade_HRGIncendiaryRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=41
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRGIncendiaryRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_HRGIncendiaryRifle_Precious"
}
