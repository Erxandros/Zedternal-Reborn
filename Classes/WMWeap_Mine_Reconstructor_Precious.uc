class WMWeap_Mine_Reconstructor_Precious extends KFWeap_Mine_Reconstructor;

defaultproperties
{
	MagazineCapacity(0)=18
	AmmoPickupScale(0)=0.75
	SpareAmmoCapacity(0)=159
	FireInterval(ALTFIRE_FIREMODE)=0.12
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=150
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Mine_Reconstructor_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Mine_Reconstructor_Precious"
}
