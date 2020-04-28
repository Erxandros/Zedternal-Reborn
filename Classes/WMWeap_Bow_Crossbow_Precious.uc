class WMWeap_Bow_Crossbow_Precious extends KFWeap_Bow_Crossbow;

defaultproperties
{
	MagazineCapacity(0)=2 //50% increase (round up)
	AmmoPickupScale(0)=1.5 //50% decrease
	SpareAmmoCapacity(0)=41 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=438.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Bow_Crossbow_Precious"
}
