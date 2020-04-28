class WMWeap_Rifle_Winchester1894_Precious extends KFWeap_Rifle_Winchester1894;

defaultproperties
{
	MagazineCapacity(0)=18 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=101 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_Winchester1894_Precious"
}
