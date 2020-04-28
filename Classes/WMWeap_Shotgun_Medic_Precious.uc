class WMWeap_Shotgun_Medic_Precious extends KFWeap_Shotgun_Medic;

defaultproperties
{
	MagazineCapacity(0)=15 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=108 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=32.0 //25% increase (round up)
	AmmoCost(ALTFIRE_FIREMODE)=32 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_Medic_Precious"
}
