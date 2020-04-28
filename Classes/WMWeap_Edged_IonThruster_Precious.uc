class WMWeap_Edged_IonThruster_Precious extends KFWeap_Edged_IonThruster;

defaultproperties
{
	InstantHitDamage(DEFAULT_FIREMODE)=115.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=190.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=107.0 //25% increase (round up)
	InstantHitDamage(CUSTOM_FIREMODE)=500 //25% increase
	MaxUltimateCharge=80.0 //20% decrease
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Edged_IonThruster_Precious"
}
