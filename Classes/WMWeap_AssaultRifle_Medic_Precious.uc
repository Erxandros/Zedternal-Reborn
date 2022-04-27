class WMWeap_AssaultRifle_Medic_Precious extends KFWeap_AssaultRifle_Medic;

defaultproperties
{
	MagazineCapacity(0)=60
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=480
	AmmoCost(ALTFIRE_FIREMODE)=24
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HealingDart_MedicBase_Precious'
	InstantHitDamage(BASH_FIREMODE)=34
	InstantHitDamage(DEFAULT_FIREMODE)=44
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_Medic_Precious"
}
