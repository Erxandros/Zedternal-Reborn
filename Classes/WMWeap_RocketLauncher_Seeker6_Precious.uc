class WMWeap_RocketLauncher_Seeker6_Precious extends KFWeap_RocketLauncher_Seeker6;

defaultproperties
{
	MagazineCapacity(0)=12
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=118
	InstantHitDamage(ALTFIRE_FIREMODE)=169
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Rocket_Seeker6_Precious'
	InstantHitDamage(BASH_FIREMODE)=40
	InstantHitDamage(DEFAULT_FIREMODE)=169
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Rocket_Seeker6_Precious'
	Name="Default__WMWeap_RocketLauncher_Seeker6_Precious"
}
