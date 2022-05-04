class WMWeap_Shotgun_Medic_Precious extends KFWeap_Shotgun_Medic;

defaultproperties
{
	MagazineCapacity(0)=20
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=126
	AmmoCost(ALTFIRE_FIREMODE)=30
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HealingDart_MedicBase_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=34
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_Medic_Precious"
}
