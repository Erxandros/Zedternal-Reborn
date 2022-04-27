class WMWeap_Pistol_DualBladed_Precious extends KFWeap_Pistol_DualBladed;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_Bladed_Precious'
	MagazineCapacity(0)=18
	AmmoPickupScale(0)=0.25
	SpareAmmoCapacity(0)=80
	InstantHitDamage(BASH_FIREMODE)=94
	InstantHitDamage(DEFAULT_FIREMODE)=144
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Blade_BladedPistol_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualBladed_Precious"
}
