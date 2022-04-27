class WMWeap_Ice_FreezeThrower_Precious extends KFWeap_Ice_FreezeThrower;

defaultproperties
{
	MagazineCapacity(0)=150
	AmmoPickupScale(0)=0.375
	SpareAmmoCapacity(0)=600
	InstantHitDamage(ALTFIRE_FIREMODE)=44
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_FreezeThrower_IceShards_Precious'
	InstantHitDamage(BASH_FIREMODE)=35
	FireInterval(DEFAULT_FIREMODE)=0.08
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Ice_FreezeThrower_Precious"
}
