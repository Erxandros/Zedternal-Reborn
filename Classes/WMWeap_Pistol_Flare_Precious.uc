class WMWeap_Pistol_Flare_Precious extends KFWeap_Pistol_Flare;

defaultproperties
{
	DualClass=Class'ZedternalReborn.WMWeap_Pistol_DualFlare_Precious'
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=1.0 //50% decrease
	SpareAmmoCapacity(0)=224 //25% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=28.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Flare_Precious"
}
