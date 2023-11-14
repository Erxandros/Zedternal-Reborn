class WMWeap_Rifle_Hemogoblin_Precious extends KFWeap_Rifle_Hemogoblin;

defaultproperties
{
	MagazineCapacity(0)=14
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=157
	AmmoCost(ALTFIRE_FIREMODE)=23
	InstantHitDamage(ALTFIRE_FIREMODE)=7
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HealingDart_MedicBase_Precious'
	InstantHitDamage(BASH_FIREMODE)=37
	InstantHitDamage(DEFAULT_FIREMODE)=162
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Hemogoblin_Precious'
	Name="Default__WMWeap_Rifle_Hemogoblin_Precious"
}
