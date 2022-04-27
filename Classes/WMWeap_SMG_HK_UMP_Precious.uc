class WMWeap_SMG_HK_UMP_Precious extends KFWeap_SMG_HK_UMP;

defaultproperties
{
	MagazineCapacity(0)=45
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=348
	InstantHitDamage(ALTFIRE_FIREMODE)=57
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=57
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_HK_UMP_Precious"
}
