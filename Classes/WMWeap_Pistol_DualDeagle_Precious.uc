class WMWeap_Pistol_DualDeagle_Precious extends KFWeap_Pistol_DualDeagle;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_Deagle_Precious'
	MagazineCapacity(0)=28
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=138
	InstantHitDamage(ALTFIRE_FIREMODE)=123
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_PistolDeagle_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=123
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_PistolDeagle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualDeagle_Precious"
}
