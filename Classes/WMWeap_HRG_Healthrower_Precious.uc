class WMWeap_HRG_Healthrower_Precious extends KFWeap_HRG_Healthrower;

defaultproperties
{
	MagazineCapacity(0)=150 //50% increase
	AmmoPickupScale(0)=0.375 //50% decrease
	SpareAmmoCapacity(0)=600 //20% increase
	FireInterval(DEFAULT_FIREMODE)=0.08 //25% increase
	AmmoCost(ALTFIRE_FIREMODE)=32 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=35 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Healthrower_Precious"
}
