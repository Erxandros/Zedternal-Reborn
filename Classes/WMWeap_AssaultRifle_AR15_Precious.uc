class WMWeap_AssaultRifle_AR15_Precious extends KFWeap_AssaultRifle_AR15;

defaultproperties
{
	MagazineCapacity(0)=40
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=336
	InstantHitDamage(ALTFIRE_FIREMODE)=41
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol9mm_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=41
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol9mm_Precious'
	Name="Default__WMWeap_AssaultRifle_AR15_Precious"
}
