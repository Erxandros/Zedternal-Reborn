class WMWeap_Pistol_DualAF2011_Precious extends KFWeap_Pistol_DualAF2011;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_AF2011_Precious'
	MagazineCapacity(0)=48
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=327
	InstantHitDamage(ALTFIRE_FIREMODE)=67
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_PistolAF2011_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=67
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_PistolAF2011_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualAF2011_Precious"
}
