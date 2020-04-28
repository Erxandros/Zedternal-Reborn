class WMWeap_AssaultRifle_MKB42_Precious extends KFWeap_AssaultRifle_MKB42;

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=324 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_MKB42_Precious"
}
