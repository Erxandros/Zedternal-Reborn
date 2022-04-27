class WMWeap_Pistol_Bladed_Precious extends KFWeap_Pistol_Bladed;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Pistol_DualBladed_Precious'
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=80
	InstantHitDamage(BASH_FIREMODE)=94
	InstantHitDamage(DEFAULT_FIREMODE)=144
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Blade_BladedPistol_Precious'
	InstantHitDamage(HEAVY_ATK_FIREMODE)=63
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Bladed_Precious"
}
