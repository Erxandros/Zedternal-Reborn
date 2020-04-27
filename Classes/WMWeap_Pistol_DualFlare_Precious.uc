class WMWeap_Pistol_DualFlare_Precious extends KFWeap_Pistol_DualFlare;

defaultproperties
{
	SingleClass=Class'ZedternalReborn.WMWeap_Pistol_Flare_Precious'
	MagazineCapacity(0)=18 //50% increase
	SpareAmmoCapacity(0)=216 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=50.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualFlare_Precious"
}
