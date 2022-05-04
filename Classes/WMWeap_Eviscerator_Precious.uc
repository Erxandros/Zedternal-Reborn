class WMWeap_Eviscerator_Precious extends KFWeap_Eviscerator;

defaultproperties
{
	MagazineCapacity(0)=10
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=35
	AmmoPickupScale(1)=0.1
	InstantHitDamage(BASH_FIREMODE)=122
	InstantHitDamage(DEFAULT_FIREMODE)=405
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Blade_Eviscerator_Precious'
	FireInterval(HEAVY_ATK_FIREMODE)=0.24
	InstantHitDamage(HEAVY_ATK_FIREMODE)=40
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Eviscerator_Precious"
}
