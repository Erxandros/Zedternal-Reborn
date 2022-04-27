class WMWeap_Pistol_DualHRGWinterbite_Precious extends KFWeap_Pistol_DualHRGWinterbite;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_HRGWinterbite_Precious'
	MagazineCapacity(0)=18
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=173
	InstantHitDamage(ALTFIRE_FIREMODE)=62
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Explosive_HRGWinterbite_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=62
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Explosive_HRGWinterbite_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualHRGWinterbite_Precious"
}
