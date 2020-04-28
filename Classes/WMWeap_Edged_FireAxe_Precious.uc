class WMWeap_Edged_FireAxe_Precious extends KFWeap_Edged_FireAxe;

defaultproperties
{
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=157.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=25.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Edged_FireAxe_Precious"
}
