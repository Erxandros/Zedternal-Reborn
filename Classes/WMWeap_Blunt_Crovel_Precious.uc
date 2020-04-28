class WMWeap_Blunt_Crovel_Precious extends KFWeap_Blunt_Crovel;

defaultproperties
{
	InstantHitDamage(DEFAULT_FIREMODE)=62.0 //25% increase (round up)
	InstantHitDamage(HEAVY_ATK_FIREMODE)=108.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=19.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Blunt_Crovel_Precious"
}
