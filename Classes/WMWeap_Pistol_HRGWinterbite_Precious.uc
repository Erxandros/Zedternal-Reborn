class WMWeap_Pistol_HRGWinterbite_Precious extends KFWeap_Pistol_HRGWinterbite;

defaultproperties
{
	DualClass=Class'ZedternalReborn.WMWeap_Pistol_DualHRGWinterbite_Precious'
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=1.0 //50% decrease
	SpareAmmoCapacity(0)=180 //20% increase
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Explosive_HRGWinterbite_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_HRGWinterbite_Precious"
}
