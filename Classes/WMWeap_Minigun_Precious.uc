class WMWeap_Minigun_Precious extends KFWeap_Minigun;

defaultproperties
{
	MagazineCapacity(0)=135 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=648 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=44.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=38.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Minigun_Precious"
}
