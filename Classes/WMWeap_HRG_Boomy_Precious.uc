class WMWeap_HRG_Boomy_Precious extends KFWeap_HRG_Boomy;

defaultproperties
{
	MagazineCapacity(0)=36 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=231 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Boomy_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=38.0 //25% increase  (round up)
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Boomy_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=38.0 //25% increase  (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase  (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Boomy_Precious"
}
