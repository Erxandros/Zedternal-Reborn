class WMWeap_Bow_Crossbow_Precious extends KFWeap_Bow_Crossbow;

defaultproperties
{
	SpareAmmoCapacity(0)=41 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=490.0 //40% increase
	FireInterval(DEFAULT_FIREMODE)=0.15 //50% increase
	InstantHitDamage(BASH_FIREMODE)=37.0 //40% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Bow_Crossbow_Precious"
}
