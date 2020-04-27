class WMWeap_Ice_FreezeThrower_Precious extends KFWeap_Ice_FreezeThrower;

defaultproperties
{
	MagazineCapacity(0)=150 //50% increase
	SpareAmmoCapacity(0)=600 //20% increase
	FireInterval(DEFAULT_FIREMODE)=0.056 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=25.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=35 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Ice_FreezeThrower_Precious"
}
