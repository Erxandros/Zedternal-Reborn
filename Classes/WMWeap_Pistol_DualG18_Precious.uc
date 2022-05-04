class WMWeap_Pistol_DualG18_Precious extends KFWeap_Pistol_DualG18;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_G18C_Precious'
	MagazineCapacity(0)=132
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=647
	InstantHitDamage(ALTFIRE_FIREMODE)=50
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_G18c_Precious'
	InstantHitDamage(BASH_FIREMODE)=34
	InstantHitDamage(DEFAULT_FIREMODE)=50
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_G18c_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualG18_Precious"
}
