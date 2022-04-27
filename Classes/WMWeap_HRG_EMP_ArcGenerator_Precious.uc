class WMWeap_HRG_EMP_ArcGenerator_Precious extends KFWeap_HRG_EMP_ArcGenerator;

defaultproperties
{
	MagazineCapacity(0)=135
	AmmoPickupScale(0)=0.25
	SpareAmmoCapacity(0)=540
	InstantHitDamage(ALTFIRE_FIREMODE)=275
	InstantHitDamage(BASH_FIREMODE)=33
	FireInterval(DEFAULT_FIREMODE)=0.08
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_EMP_ArcGenerator_Precious"
}
