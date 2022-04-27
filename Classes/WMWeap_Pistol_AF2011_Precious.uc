class WMWeap_Pistol_AF2011_Precious extends KFWeap_Pistol_AF2011;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Pistol_DualAF2011_Precious'
	MagazineCapacity(0)=24
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=346
	InstantHitDamage(BASH_FIREMODE)=28
	InstantHitDamage(DEFAULT_FIREMODE)=67
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_PistolAF2011_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_AF2011_Precious"
}
