class WMWeap_Pistol_Dual9mm_Precious extends KFWeap_Pistol_Dual9mm;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_9mm_Precious'
	MagazineCapacity(0)=60
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=84
	InstantHitDamage(ALTFIRE_FIREMODE)=34
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol9mm_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=34
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol9mm_Precious'
	Name="Default__WMWeap_Pistol_Dual9mm_Precious"
}
