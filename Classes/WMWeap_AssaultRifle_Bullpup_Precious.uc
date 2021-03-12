class WMWeap_AssaultRifle_Bullpup_Precious extends KFWeap_AssaultRifle_Bullpup;

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=324 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=40.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=40.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_Bullpup_Precious"
}
