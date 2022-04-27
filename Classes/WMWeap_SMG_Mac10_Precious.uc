class WMWeap_SMG_Mac10_Precious extends KFWeap_SMG_Mac10;

defaultproperties
{
	MagazineCapacity(0)=48
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=461
	InstantHitDamage(ALTFIRE_FIREMODE)=35
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Mac10_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=35
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Mac10_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_Mac10_Precious"
}
