class WMWeap_Pistol_DualFlare_Precious extends KFWeap_Pistol_DualFlare;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_Flare_Precious'
	MagazineCapacity(0)=24
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=252
	InstantHitDamage(ALTFIRE_FIREMODE)=54
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_FlareGun_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=54
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_FlareGun_Precious'
	Name="Default__WMWeap_Pistol_DualFlare_Precious"
}
