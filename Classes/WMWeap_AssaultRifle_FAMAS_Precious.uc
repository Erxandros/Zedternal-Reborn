class WMWeap_AssaultRifle_FAMAS_Precious extends KFWeap_AssaultRifle_FAMAS;

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=288 //20% increase
	MagazineCapacity(1)=9 //50% increase
	AmmoPickupScale(1)=0.5 //50% decrease
	SpareAmmoCapacity(1)=44 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=44.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=38.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_FAMAS_Precious"
}
