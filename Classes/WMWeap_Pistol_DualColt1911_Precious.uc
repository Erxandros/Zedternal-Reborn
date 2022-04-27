class WMWeap_Pistol_DualColt1911_Precious extends KFWeap_Pistol_DualColt1911;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_Colt1911_Precious'
	MagazineCapacity(0)=24
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=154
	InstantHitDamage(ALTFIRE_FIREMODE)=63
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_PistolColt1911_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=63
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_PistolColt1911_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualColt1911_Precious"
}
