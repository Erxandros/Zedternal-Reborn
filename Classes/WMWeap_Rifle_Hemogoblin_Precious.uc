class WMWeap_Rifle_Hemogoblin_Precious extends KFWeap_Rifle_Hemogoblin;

defaultproperties
{
	MagazineCapacity(0)=11 //50% increase (round up)
	SpareAmmoCapacity(0)=118 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=125.0 //25% increase
	AmmoCost(ALTFIRE_FIREMODE)=24 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=34.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_Hemogoblin_Precious"
}
