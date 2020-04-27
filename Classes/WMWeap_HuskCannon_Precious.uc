class WMWeap_HuskCannon_Precious extends KFWeap_HuskCannon;

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	SpareAmmoCapacity(0)=180 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=35.0 //25% increase
	MaxChargeTime=0.800000 //20% decrease
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HuskCannon_Precious"
}
