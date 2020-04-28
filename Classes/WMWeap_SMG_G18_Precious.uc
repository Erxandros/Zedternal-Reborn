class WMWeap_SMG_G18_Precious extends KFWeap_SMG_G18;

defaultproperties
{
	MagazineCapacity(0)=50 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=555 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=35.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=35.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=44.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_G18_Precious"
}
