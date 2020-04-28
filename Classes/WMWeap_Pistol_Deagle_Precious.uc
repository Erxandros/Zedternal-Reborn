class WMWeap_Pistol_Deagle_Precious extends KFWeap_Pistol_Deagle;

defaultproperties
{
	DualClass=Class'ZedternalReborn.WMWeap_Pistol_DualDeagle_Precious'
	MagazineCapacity(0)=11 //50% increase (round up)
	AmmoPickupScale(0)=1.0 //50% decrease
	SpareAmmoCapacity(0)=126 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=114.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=28.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Deagle_Precious"
}
