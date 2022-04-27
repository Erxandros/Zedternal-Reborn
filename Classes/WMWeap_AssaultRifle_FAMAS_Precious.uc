class WMWeap_AssaultRifle_FAMAS_Precious extends KFWeap_AssaultRifle_FAMAS;

defaultproperties
{
	MagazineCapacity(0)=45
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=288
	MagazineCapacity(1)=9
	AmmoPickupScale(1)=0.5
	SpareAmmoCapacity(1)=44
	InstantHitDamage(ALTFIRE_FIREMODE)=38
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=44
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_FAMAS_Precious"
}
