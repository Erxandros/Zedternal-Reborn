class WMWeap_Pistol_Blunderbuss_Precious extends WMWeap_Pistol_Blunderbuss;

defaultproperties
{
	MagazineCapacity(0)=6
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=55
	InstantHitDamage(ALTFIRE_FIREMODE)=68
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Nail_Blunderbuss_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=405
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Cannonball_Blunderbuss_Precious'
	Name="Default__WMWeap_Pistol_Blunderbuss_Precious"
}
