class WMWeap_SMG_MP5RAS_Precious extends KFWeap_SMG_MP5RAS;

defaultproperties
{
	MagazineCapacity(0)=60 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=384 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=32.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=32.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_MP5RAS_Precious"
}
