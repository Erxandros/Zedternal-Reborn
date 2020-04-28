class WMWeap_Rifle_M99_Precious extends KFWeap_Rifle_M99;

defaultproperties
{
	MagazineCapacity(0)=2 //50% increase (round up)
	AmmoPickupScale(0)=1.0 //50% decrease
	SpareAmmoCapacity(0)=24 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=1063.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=38.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_M99_Precious"
}
