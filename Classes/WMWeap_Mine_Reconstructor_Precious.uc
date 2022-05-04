class WMWeap_Mine_Reconstructor_Precious extends KFWeap_Mine_Reconstructor;

defaultproperties
{
	MagazineCapacity(0)=24
	AmmoPickupScale(0)=0.75
	SpareAmmoCapacity(0)=185
	FireInterval(ALTFIRE_FIREMODE)=0.12
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=162
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Mine_Reconstructor_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Mine_Reconstructor_Precious"
}
