class WMWeap_SMG_G18_Precious extends KFWeap_SMG_G18;

defaultproperties
{
	MagazineCapacity(0)=66
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=647
	InstantHitDamage(ALTFIRE_FIREMODE)=38
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_G18_Precious'
	InstantHitDamage(BASH_FIREMODE)=48
	InstantHitDamage(DEFAULT_FIREMODE)=38
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_G18_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_G18_Precious"
}
