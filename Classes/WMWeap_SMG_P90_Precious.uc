class WMWeap_SMG_P90_Precious extends KFWeap_SMG_P90;

defaultproperties
{
	MagazineCapacity(0)=100
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=490
	InstantHitDamage(ALTFIRE_FIREMODE)=41
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=34
	InstantHitDamage(DEFAULT_FIREMODE)=41
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	Name="Default__WMWeap_SMG_P90_Precious"
}
