class WMWeap_Pistol_DualG18_Precious extends KFWeap_Pistol_DualG18;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_G18C_Precious'
	MagazineCapacity(0)=99
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=555
	InstantHitDamage(ALTFIRE_FIREMODE)=47
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_G18c_Precious'
	InstantHitDamage(BASH_FIREMODE)=32
	InstantHitDamage(DEFAULT_FIREMODE)=47
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_G18c_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualG18_Precious"
}
