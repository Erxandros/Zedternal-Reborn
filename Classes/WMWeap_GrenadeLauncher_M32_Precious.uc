class WMWeap_GrenadeLauncher_M32_Precious extends KFWeap_GrenadeLauncher_M32;

defaultproperties
{
	MagazineCapacity(0)=12
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=51
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=203
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_HighExplosive_M32_Precious'
	Name="Default__WMWeap_GrenadeLauncher_M32_Precious"
}
