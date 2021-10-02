class WMWeap_Pistol_DualBladed_Precious extends KFWeap_Pistol_DualBladed;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_Bladed_Precious'
	MagazineCapacity(0)=18 //50% increase
	AmmoPickupScale(0)=0.25 //50% decrease
	SpareAmmoCapacity(0)=80 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=144.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=94.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualBladed_Precious"
}
