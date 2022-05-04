class WMWeap_SMG_MP5RAS_Precious extends KFWeap_SMG_MP5RAS;

defaultproperties
{
	MagazineCapacity(0)=80
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=448
	InstantHitDamage(ALTFIRE_FIREMODE)=34
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=34
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_MP5RAS_Precious"
}
