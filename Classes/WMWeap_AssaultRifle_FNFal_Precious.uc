class WMWeap_AssaultRifle_FNFal_Precious extends KFWeap_AssaultRifle_FNFal;

defaultproperties
{
	MagazineCapacity(0)=30
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=192
	InstantHitDamage(ALTFIRE_FIREMODE)=88
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=88
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_FNFal_Precious"
}
