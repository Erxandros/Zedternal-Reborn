class WMWeap_Pistol_ChiappaRhino_Precious extends KFWeap_Pistol_ChiappaRhino;

defaultproperties
{
	DualClass=Class'ZedternalReborn.WMWeap_Pistol_ChiappaRhinoDual_Precious'
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=1.0 //50% decrease
	SpareAmmoCapacity(0)=137 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=88.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_ChiappaRhino_Precious"
}
