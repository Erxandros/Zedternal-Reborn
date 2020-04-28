class WMWeap_HRG_Revolver_Buckshot_Precious extends KFWeap_HRG_Revolver_Buckshot;

defaultproperties
{
	DualClass=Class'ZedternalReborn.WMWeap_HRG_Revolver_DualBuckshot_Precious'
	MagazineCapacity(0)=8 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=102 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=40.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=29.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Revolver_Buckshot_Precious"
}