class WMWeap_HighExplosive_M16M203_Precious extends KFWeap_AssaultRifle_M16M203;

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	SpareAmmoCapacity(0)=324 //20% increase
	MagazineCapacity(1)=2 //50% increase (round up)
	SpareAmmoCapacity(1)=16 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=42.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=288.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	WeaponProjectiles(1)=Class'ZedternalReborn.WMProj_HighExplosive_M16M203_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HighExplosive_M16M203_Precious"
}
