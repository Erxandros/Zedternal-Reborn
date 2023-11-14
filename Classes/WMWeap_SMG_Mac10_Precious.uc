class WMWeap_SMG_Mac10_Precious extends KFWeap_SMG_Mac10;

defaultproperties
{
	MagazineCapacity(0)=64
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=538
	InstantHitDamage(ALTFIRE_FIREMODE)=38
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Mac10_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=38
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Mac10_Precious'
	Name="Default__WMWeap_SMG_Mac10_Precious"
}
