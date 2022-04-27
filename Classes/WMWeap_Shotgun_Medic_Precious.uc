class WMWeap_Shotgun_Medic_Precious extends KFWeap_Shotgun_Medic;

defaultproperties
{
	MagazineCapacity(0)=15
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=108
	AmmoCost(ALTFIRE_FIREMODE)=32
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HealingDart_MedicBase_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=32
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_Medic_Precious"
}
