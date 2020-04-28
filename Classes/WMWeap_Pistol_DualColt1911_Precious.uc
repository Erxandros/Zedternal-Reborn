class WMWeap_Pistol_DualColt1911_Precious extends KFWeap_Pistol_DualColt1911;

defaultproperties
{
	SingleClass=Class'ZedternalReborn.WMWeap_Pistol_Colt1911_Precious'
	MagazineCapacity(0)=24 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=154 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualColt1911_Precious"
}
