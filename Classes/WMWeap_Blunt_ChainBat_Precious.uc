class WMWeap_Blunt_ChainBat_Precious extends KFWeap_Blunt_ChainBat;

defaultproperties
{
	InstantHitDamage(DEFAULT_FIREMODE)=85.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=113.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=85.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Blunt_ChainBat_Precious"
}
