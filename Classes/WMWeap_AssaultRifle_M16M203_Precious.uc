class WMWeap_AssaultRifle_M16M203_Precious extends WMWeap_AssaultRifle_M16M203;

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=324 //20% increase
	MagazineCapacity(1)=2 //50% increase (round up)
	AmmoPickupScale(1)=1.0 //50% decrease
	SpareAmmoCapacity(1)=16 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=42.0 //25% increase (round up)
	WeaponProjectiles(ALTFIRE_FIREMODE)=Class'ZedternalReborn.WMProj_HighExplosive_M16M203_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=288.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_M16M203_Precious"
}
