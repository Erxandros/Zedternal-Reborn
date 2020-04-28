class WMWeap_Pistol_DualAF2011_Precious extends KFWeap_Pistol_DualAF2011;

defaultproperties
{
	SingleClass=Class'ZedternalReborn.WMWeap_Pistol_AF2011_Precious'
	MagazineCapacity(0)=48 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=327 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=67.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=67.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualAF2011_Precious"
}
