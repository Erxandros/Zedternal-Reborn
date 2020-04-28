class WMWeap_Blunt_PowerGloves_Precious extends KFWeap_Blunt_PowerGloves;

defaultproperties
{
	InstantHitDamage(DEFAULT_FIREMODE)=119.0 //25% increase (round up)
	InstantHitDamage(HEAVY_ATK_FIREMODE)=219.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=125.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Blunt_PowerGloves_Precious"
}
