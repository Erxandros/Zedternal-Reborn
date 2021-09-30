class WMWeap_HRG_BlastBrawlers_Precious extends WMWeap_HRG_BlastBrawlers;

defaultproperties
{
	MagazineCapacity(0)=6 //50% increase
	AmmoPickupScale(0)=0.75 //50% decrease
	SpareAmmoCapacity(0)=48 //20% increase
	InstantHitDamage(CUSTOM_FIREMODE)=49.0 //25% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(HEAVY_ATK_FIREMODE)=250.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=125.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_BlastBrawlers_Precious"
}
