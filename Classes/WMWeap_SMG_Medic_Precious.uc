class WMWeap_SMG_Medic_Precious extends KFWeap_SMG_Medic;

defaultproperties
{
	MagazineCapacity(0)=60 //50% increase
	SpareAmmoCapacity(0)=576 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=25.0 //25% increase
	AmmoCost(ALTFIRE_FIREMODE)=32 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=29.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_Medic_Precious"
}
