class WMWeap_Pistol_G18C_Precious extends KFWeap_Pistol_G18C;

defaultproperties
{
	DualClass=Class'ZedternalReborn.WMWeap_Pistol_DualG18_Precious'
	MagazineCapacity(0)=50 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=555 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=47.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=47.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_G18C_Precious"
}
