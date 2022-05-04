class WMWeap_Ice_FreezeThrower_Precious extends KFWeap_Ice_FreezeThrower;

defaultproperties
{
	MagazineCapacity(0)=200
	AmmoPickupScale(0)=0.375
	SpareAmmoCapacity(0)=700
	InstantHitDamage(ALTFIRE_FIREMODE)=48
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_FreezeThrower_IceShards_Precious'
	InstantHitDamage(BASH_FIREMODE)=38
	FireInterval(DEFAULT_FIREMODE)=0.075
	MinAmmoConsumed=2
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Ice_FreezeThrower_Precious"
}
