class WMWeap_SMG_MP7_Precious extends KFWeap_SMG_MP7;

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=396 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=20.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=20.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_MP7_Precious"
}
