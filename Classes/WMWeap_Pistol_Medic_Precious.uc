class WMWeap_Pistol_Medic_Precious extends KFWeap_Pistol_Medic;

defaultproperties
{
	MagazineCapacity(0)=23 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=288 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=25.0 //25% increase
	AmmoCost(ALTFIRE_FIREMODE)=40 //20% decrease
	InstantHitDamage(BASH_FIREMODE)=27.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Medic_Precious"
}
