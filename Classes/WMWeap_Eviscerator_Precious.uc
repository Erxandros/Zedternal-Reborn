class WMWeap_Eviscerator_Precious extends KFWeap_Eviscerator;

defaultproperties
{
	MagazineCapacity(0)=8 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=30 //20% increase
	AmmoPickupScale(1)=0.1 //50% decrease
	InstantHitDamage(DEFAULT_FIREMODE)=375.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=37.0 //25% increase (round up)
	FireInterval(HEAVY_ATK_FIREMODE)=+0.24 //50% increase
	InstantHitDamage(BASH_FIREMODE)=113.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Eviscerator_Precious"
}
