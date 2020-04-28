class WMWeap_SMG_Mac10_Precious extends KFWeap_SMG_Mac10;

defaultproperties
{
	MagazineCapacity(0)=48 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=461 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=32.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=32.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_Mac10_Precious"
}
