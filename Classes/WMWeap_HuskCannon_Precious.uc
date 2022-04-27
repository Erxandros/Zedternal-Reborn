class WMWeap_HuskCannon_Precious extends KFWeap_HuskCannon;

defaultproperties
{
	MagazineCapacity(0)=45
	AmmoPickupScale(0)=0.375
	SpareAmmoCapacity(0)=180
	InstantHitDamage(BASH_FIREMODE)=35
	InstantHitDamage(DEFAULT_FIREMODE)=50
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_HuskCannon_Fireball_Precious'
	MaxChargeTime=0.8
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HuskCannon_Precious"
}
