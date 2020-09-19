class WMWeap_Pistol_HRGScorcher_Precious extends KFWeap_Pistol_HRGScorcher;

defaultproperties
{
	MagazineCapacity(0)=2 //50% increase (round up)
	AmmoPickupScale(0)=2.0 //50% decrease
	SpareAmmoCapacity(0)=38 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=417.0 //25% increase (round up)
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'WMProj_BrokenFlare_HRGScorcher_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=88.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_HRGScorcher_Precious"
}
