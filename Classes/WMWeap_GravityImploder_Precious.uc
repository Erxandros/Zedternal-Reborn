class WMWeap_GravityImploder_Precious extends KFWeap_GravityImploder;

defaultproperties
{
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=51
	InstantHitDamage(ALTFIRE_FIREMODE)=250
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Grenade_GravityImploderAlt_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=188
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Grenade_GravityImploder_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_GravityImploder_Precious"
}
