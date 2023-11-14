class WMWeap_AssaultRifle_MedicRifleGrenadeLauncher_Precious extends WMWeap_AssaultRifle_MedicRifleGrenadeLauncher;

defaultproperties
{
	MagazineCapacity(0)=60
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=294
	MagazineCapacity(1)=2
	AmmoPickupScale(1)=1
	SpareAmmoCapacity(1)=13
	InstantHitDamage(ALTFIRE_FIREMODE)=68
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_MedicGrenade_Mini_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=64
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	Name="Default__WMWeap_AssaultRifle_MedicRifleGrenadeLauncher_Precious"
}
