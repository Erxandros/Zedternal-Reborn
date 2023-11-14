class WMWeap_AssaultRifle_LazerCutter_Precious extends KFWeap_AssaultRifle_LazerCutter;

defaultproperties
{
	MagazineCapacity(0)=100
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=630
	InstantHitDamage(ALTFIRE_FIREMODE)=54
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_LazerCutter_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=75
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_LazerCutter_Precious'
	Name="Default__WMWeap_AssaultRifle_LazerCutter_Precious"
}
