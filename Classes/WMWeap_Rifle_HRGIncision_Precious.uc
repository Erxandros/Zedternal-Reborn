class WMWeap_Rifle_HRGIncision_Precious extends KFWeap_Rifle_HRGIncision;

defaultproperties
{
	MagazineCapacity(0)=2 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=47 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=500 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=94 //25% increase (round up)
	AmmoCost(ALTFIRE_FIREMODE)=40 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=38.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_HRGIncision_Precious"
}
