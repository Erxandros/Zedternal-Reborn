class WMWeap_AssaultRifle_LazerCutter_Precious extends KFWeap_AssaultRifle_LazerCutter;

defaultproperties
{
	MagazineCapacity(0)=75 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=360 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_LazerCutter_Precious"
}
