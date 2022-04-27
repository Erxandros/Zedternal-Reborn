class WMWeap_AssaultRifle_MKB42_Precious extends KFWeap_AssaultRifle_MKB42;

defaultproperties
{
	MagazineCapacity(0)=45
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=324
	InstantHitDamage(ALTFIRE_FIREMODE)=63
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=63
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_MKB42_Precious"
}
