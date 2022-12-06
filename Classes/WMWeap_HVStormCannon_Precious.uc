class WMWeap_HVStormCannon_Precious extends KFWeap_HVStormCannon;

defaultproperties
{
	MagazineCapacity(0)=16
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=135
	InstantHitDamage(BASH_FIREMODE)=37
	InstantHitDamage(DEFAULT_FIREMODE)=203
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HVStormCannon_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HVStormCannon_Precious"
}
