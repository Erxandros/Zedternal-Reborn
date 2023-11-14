class WMWeap_AssaultRifle_FNFal_Precious extends KFWeap_AssaultRifle_FNFal;

defaultproperties
{
	MagazineCapacity(0)=40
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=224
	InstantHitDamage(ALTFIRE_FIREMODE)=95
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=95
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	Name="Default__WMWeap_AssaultRifle_FNFal_Precious"
}
