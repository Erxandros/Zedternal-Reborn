class WMWeap_Flame_CaulkBurn_Precious extends KFWeap_Flame_CaulkBurn;

defaultproperties
{
	MagazineCapacity(0)=75 //50% increase
	AmmoPickupScale(0)=0.25 //50% decrease
	SpareAmmoCapacity(0)=600 //20% increase
	FireInterval(DEFAULT_FIREMODE)=0.056 //25% increase
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Flame_CaulkBurn_Precious"
}
