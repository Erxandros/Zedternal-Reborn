class WMWeap_Pistol_Blunderbuss_Precious extends KFWeap_Pistol_Blunderbuss;

defaultproperties
{
	MagazineCapacity(0)=5
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=47
	InstantHitDamage(ALTFIRE_FIREMODE)=63
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Nail_Blunderbuss_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=375
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Cannonball_Blunderbuss_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Blunderbuss_Precious"
}
