class WMWeap_Pistol_Colt1911_Precious extends KFWeap_Pistol_Colt1911;

defaultproperties
{
	DualClass=Class'ZedternalReborn.WMWeap_Pistol_DualColt1911_Precious'
	MagazineCapacity(0)=12 //50% increase
	SpareAmmoCapacity(0)=164 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=28.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Colt1911_Precious"
}
