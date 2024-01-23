class WMWeap_GravityImploder_Precious extends KFWeap_GravityImploder;

defaultproperties
{
	MagazineCapacity(0)=12
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=59
	InstantHitDamage(ALTFIRE_FIREMODE)=270
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Grenade_GravityImploderAlt_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=203
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Grenade_GravityImploder_Precious'
	Name="Default__WMWeap_GravityImploder_Precious"
}
