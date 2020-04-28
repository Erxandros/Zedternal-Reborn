class WMWeap_Edged_AbominationAxe_Precious extends KFWeap_Edged_AbominationAxe;

defaultproperties
{
	InstantHitDamage(DEFAULT_FIREMODE)=150.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=313.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=127.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Edged_AbominationAxe_Precious"
}
