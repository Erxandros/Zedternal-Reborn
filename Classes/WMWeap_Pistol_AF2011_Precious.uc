class WMWeap_Pistol_AF2011_Precious extends KFWeap_Pistol_AF2011;

defaultproperties
{
	DualClass=Class'ZedternalReborn.WMWeap_Pistol_DualAF2011_Precious'
	MagazineCapacity(0)=24 //50% increase (round up)
	AmmoPickupScale(0)=1.0 //50% decrease
	SpareAmmoCapacity(0)=346 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=67.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=28.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_AF2011_Precious"
}
