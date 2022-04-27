class WMWeap_Pistol_Medic_Precious extends KFWeap_Pistol_Medic;

defaultproperties
{
	MagazineCapacity(0)=23
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=288
	AmmoCost(ALTFIRE_FIREMODE)=40
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HealingDart_MedicBase_Precious'
	InstantHitDamage(BASH_FIREMODE)=27
	InstantHitDamage(DEFAULT_FIREMODE)=25
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol9mm_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Medic_Precious"
}
