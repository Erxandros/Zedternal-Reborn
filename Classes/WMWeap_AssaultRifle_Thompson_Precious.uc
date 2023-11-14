class WMWeap_AssaultRifle_Thompson_Precious extends KFWeap_AssaultRifle_Thompson;

defaultproperties
{
	MagazineCapacity(0)=100
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=350
	InstantHitDamage(ALTFIRE_FIREMODE)=41
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=41
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	Name="Default__WMWeap_AssaultRifle_Thompson_Precious"
}
