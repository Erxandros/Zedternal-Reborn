class WMWeap_Mine_Reconstructor_Precious extends KFWeap_Mine_Reconstructor;

defaultproperties
{
	MagazineCapacity(0)=18 //50% increase
	AmmoPickupScale(0)=0.75 //50% decrease
	SpareAmmoCapacity(0)=159 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=class'WMProj_Mine_Reconstructor_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=150.0 //25% increase
	FireInterval(ALTFIRE_FIREMODE)=0.12 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Mine_Reconstructor_Precious"
}
