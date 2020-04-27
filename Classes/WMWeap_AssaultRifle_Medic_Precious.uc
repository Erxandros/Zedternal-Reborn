class WMWeap_AssaultRifle_Medic_Precious extends KFWeap_AssaultRifle_Medic;

defaultproperties
{
	MagazineCapacity(0)=60 //50% increase
	SpareAmmoCapacity(0)=480 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=44.0 //25% increase (round up)
	AmmoCost(ALTFIRE_FIREMODE)=30 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=34.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_Medic_Precious"
}
