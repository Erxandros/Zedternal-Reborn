class WMWeap_Pistol_HRGScorcher_Precious extends KFWeap_Pistol_HRGScorcher;

defaultproperties
{
	MagazineCapacity(0)=2
	AmmoPickupScale(0)=2
	SpareAmmoCapacity(0)=38
	InstantHitDamage(ALTFIRE_FIREMODE)=88
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_BrokenFlare_HRGScorcher_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=417
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_HRGScorcher_Precious"
}
