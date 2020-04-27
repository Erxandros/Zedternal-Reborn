class WMWeap_SMG_Kriss_Precious extends KFWeap_SMG_Kriss;

defaultproperties
{
	MagazineCapacity(0)=50 //50% increase (round up)
	SpareAmmoCapacity(0)=594 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=42.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=42.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_Kriss_Precious"
}
