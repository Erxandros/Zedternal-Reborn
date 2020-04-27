class WMWeap_Blunt_MaceAndShield_Precious extends KFWeap_Blunt_MaceAndShield;

defaultproperties
{
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=219.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=207.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Blunt_MaceAndShield_Precious"
}
