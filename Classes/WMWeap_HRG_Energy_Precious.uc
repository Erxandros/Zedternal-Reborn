class WMWeap_HRG_Energy_Precious extends KFWeap_HRG_Energy;

defaultproperties
{
	MagazineCapacity(0)=23 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=144 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=150.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Energy_Precious"
}
