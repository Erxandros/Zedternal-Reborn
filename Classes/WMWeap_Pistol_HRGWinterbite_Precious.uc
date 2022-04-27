class WMWeap_Pistol_HRGWinterbite_Precious extends KFWeap_Pistol_HRGWinterbite;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Pistol_DualHRGWinterbite_Precious'
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=180
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=62
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Explosive_HRGWinterbite_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_HRGWinterbite_Precious"
}
