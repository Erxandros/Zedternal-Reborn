class WMWeap_HuskCannon_Precious extends KFWeap_HuskCannon;

defaultproperties
{
	MagazineCapacity(0)=60
	AmmoPickupScale(0)=0.375
	SpareAmmoCapacity(0)=210
	InstantHitDamage(BASH_FIREMODE)=38
	InstantHitDamage(DEFAULT_FIREMODE)=54
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_HuskCannon_Fireball_Precious'
	MaxChargeTime=0.75
	Name="Default__WMWeap_HuskCannon_Precious"
}
