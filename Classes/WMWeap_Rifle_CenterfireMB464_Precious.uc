class WMWeap_Rifle_CenterfireMB464_Precious extends KFWeap_Rifle_CenterfireMB464;

defaultproperties
{
	MagazineCapacity(0)=15 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=84 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=207.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_CenterfireMB464_Precious"
}
