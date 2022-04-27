class WMWeap_SMG_Medic_Precious extends KFWeap_SMG_Medic;

defaultproperties
{
	MagazineCapacity(0)=60
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=576
	AmmoCost(ALTFIRE_FIREMODE)=32
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HealingDart_MedicBase_Precious'
	InstantHitDamage(BASH_FIREMODE)=29
	InstantHitDamage(DEFAULT_FIREMODE)=25
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_Medic_Precious"
}
