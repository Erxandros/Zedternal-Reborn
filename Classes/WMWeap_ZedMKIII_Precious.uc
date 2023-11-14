class WMWeap_ZedMKIII_Precious extends KFWeap_ZedMKIII;

defaultproperties
{
	MagazineCapacity(0)=100
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=490
	InstantHitDamage(ALTFIRE_FIREMODE)=135
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Rocket_ZedMKIII_Precious'
	InstantHitDamage(BASH_FIREMODE)=37
	InstantHitDamage(DEFAULT_FIREMODE)=68
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_ZedMKIII_Precious'
	Name="Default__WMWeap_ZedMKIII_Precious"
}
