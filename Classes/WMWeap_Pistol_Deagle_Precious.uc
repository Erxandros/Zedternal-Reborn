class WMWeap_Pistol_Deagle_Precious extends KFWeap_Pistol_Deagle;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Pistol_DualDeagle_Precious'
	MagazineCapacity(0)=11
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=126
	InstantHitDamage(BASH_FIREMODE)=28
	InstantHitDamage(DEFAULT_FIREMODE)=114
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol50AE_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Deagle_Precious"
}
