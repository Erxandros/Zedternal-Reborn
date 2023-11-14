class WMWeap_AssaultRifle_FAMAS_Precious extends KFWeap_AssaultRifle_FAMAS;

defaultproperties
{
	MagazineCapacity(0)=60
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=336
	MagazineCapacity(1)=12
	AmmoPickupScale(1)=0.5
	SpareAmmoCapacity(1)=51
	InstantHitDamage(ALTFIRE_FIREMODE)=41
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=48
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	Name="Default__WMWeap_AssaultRifle_FAMAS_Precious"
}
