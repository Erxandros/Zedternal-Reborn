class WMWeap_GravityImploder_Precious extends KFWeap_GravityImploder;

defaultproperties
{
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=51 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Grenade_GravityImploder_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=188.0 //25% increase (round up)
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Grenade_GravityImploderAlt_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=250.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_GravityImploder_Precious"
}
