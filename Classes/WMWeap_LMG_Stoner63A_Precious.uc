class WMWeap_LMG_Stoner63A_Precious extends KFWeap_LMG_Stoner63A;

defaultproperties
{
	MagazineCapacity(0)=113 //50% increase (round up)
	SpareAmmoCapacity(0)=600 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=38.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_LMG_Stoner63A_Precious"
}
