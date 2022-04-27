class WMWeap_RocketLauncher_Seeker6_Precious extends KFWeap_RocketLauncher_Seeker6;

defaultproperties
{
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=101
	InstantHitDamage(ALTFIRE_FIREMODE)=157
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Rocket_Seeker6_Precious'
	InstantHitDamage(BASH_FIREMODE)=37
	InstantHitDamage(DEFAULT_FIREMODE)=157
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Rocket_Seeker6_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_RocketLauncher_Seeker6_Precious"
}
