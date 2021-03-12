class WMWeap_Ice_FreezeThrower_Precious extends KFWeap_Ice_FreezeThrower;

defaultproperties
{
	MagazineCapacity(0)=150 //50% increase
	AmmoPickupScale(0)=0.375 //50% decrease
	SpareAmmoCapacity(0)=600 //20% increase
	FireInterval(DEFAULT_FIREMODE)=0.08 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=44.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=35 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Ice_FreezeThrower_Precious"
}
