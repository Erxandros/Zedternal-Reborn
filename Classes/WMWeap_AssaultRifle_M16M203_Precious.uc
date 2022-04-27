class WMWeap_AssaultRifle_M16M203_Precious extends WMWeap_AssaultRifle_M16M203;

defaultproperties
{
	MagazineCapacity(0)=45
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=324
	MagazineCapacity(1)=2
	AmmoPickupScale(1)=1
	SpareAmmoCapacity(1)=16
	InstantHitDamage(ALTFIRE_FIREMODE)=288
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HighExplosive_M16M203_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=42
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_M16M203_Precious"
}
