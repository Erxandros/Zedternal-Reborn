class WMWeap_Pistol_DualHRGWinterbite_Precious extends KFWeap_Pistol_DualHRGWinterbite;

defaultproperties
{
	SingleClass=Class'ZedternalReborn.WMWeap_Pistol_HRGWinterbite_Precious'
	MagazineCapacity(0)=18 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=173 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Explosive_HRGWinterbite_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=50.0 //25% increase
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Explosive_HRGWinterbite_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualHRGWinterbite_Precious"
}
