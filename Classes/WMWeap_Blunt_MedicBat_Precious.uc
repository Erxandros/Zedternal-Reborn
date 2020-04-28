class WMWeap_Blunt_MedicBat_Precious extends KFWeap_Blunt_MedicBat;

defaultproperties
{
	MagazineCapacity(0)=5 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=15 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	AmmoCost(DEFAULT_FIREMODE)=32 //20% decrease
	InstantHitDamage(HEAVY_ATK_FIREMODE)=163.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=50.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Blunt_MedicBat_Precious"
}
