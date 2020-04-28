class WMWeap_Rifle_M14EBR_Precious extends KFWeap_Rifle_M14EBR;

defaultproperties
{
	MagazineCapacity(0)=30 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=144 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=34.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_M14EBR_Precious"
}
