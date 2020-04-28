class WMWeap_AssaultRifle_AR15_Precious extends KFWeap_AssaultRifle_AR15;

defaultproperties
{
	MagazineCapacity(0)=30 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=288 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=38.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=38.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_AR15_Precious"
}
