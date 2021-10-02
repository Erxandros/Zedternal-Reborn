class WMWeap_Rifle_MosinNagant_Precious extends KFWeap_Rifle_MosinNagant;

defaultproperties
{
	MagazineCapacity(0)=8 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=72 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=313.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=125.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_MosinNagant_Precious"
}
