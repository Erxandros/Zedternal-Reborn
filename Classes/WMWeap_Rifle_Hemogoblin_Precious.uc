class WMWeap_Rifle_Hemogoblin_Precious extends KFWeap_Rifle_Hemogoblin;

defaultproperties
{
	MagazineCapacity(0)=11
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=135
	AmmoCost(ALTFIRE_FIREMODE)=24
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HealingDart_MedicBase_Precious'
	InstantHitDamage(BASH_FIREMODE)=34
	InstantHitDamage(DEFAULT_FIREMODE)=150
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Hemogoblin_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_Hemogoblin_Precious"
}
