class WMWeap_HRG_Locust_Precious extends KFWeap_HRG_Locust;

defaultproperties
{
	MagazineCapacity(0)=12
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=118
	InstantHitDamage(ALTFIRE_FIREMODE)=2
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HRG_Locust_Precious'
	InstantHitDamage(BASH_FIREMODE)=40
	InstantHitDamage(DEFAULT_FIREMODE)=2
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_HRG_Locust_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Locust_Precious"
}
