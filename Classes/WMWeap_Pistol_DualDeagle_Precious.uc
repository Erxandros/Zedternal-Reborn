class WMWeap_Pistol_DualDeagle_Precious extends KFWeap_Pistol_DualDeagle;

defaultproperties
{
	SingleClass=Class'ZedternalReborn.WMWeap_Pistol_Deagle_Precious'
	MagazineCapacity(0)=22 //50% increase (round up)
	SpareAmmoCapacity(0)=118 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=114.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=114.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualDeagle_Precious"
}
