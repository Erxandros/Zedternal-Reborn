class WMWeap_AssaultRifle_MedicRifleGrenadeLauncher_Precious extends WMWeap_AssaultRifle_MedicRifleGrenadeLauncher;

defaultproperties
{
	MagazineCapacity(0)=45
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=252
	MagazineCapacity(1)=2
	AmmoPickupScale(1)=1
	SpareAmmoCapacity(1)=11
	InstantHitDamage(ALTFIRE_FIREMODE)=63
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_MedicGrenade_Mini_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=59
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_MedicRifleGrenadeLauncher_Precious"
}
