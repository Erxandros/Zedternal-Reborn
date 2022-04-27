class WMWeap_SMG_P90_Precious extends KFWeap_SMG_P90;

defaultproperties
{
	MagazineCapacity(0)=75
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=420
	InstantHitDamage(ALTFIRE_FIREMODE)=38
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=32
	InstantHitDamage(DEFAULT_FIREMODE)=38
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_P90_Precious"
}
