class WMWeap_Rifle_RailGun_Precious extends KFWeap_Rifle_RailGun;

defaultproperties
{
	MagazineCapacity(0)=2 //50% increase (round up)
	AmmoPickupScale(0)=1.5 //50% decrease
	SpareAmmoCapacity(0)=39 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=350.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=700.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=38.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_RailGun_Precious"
}
