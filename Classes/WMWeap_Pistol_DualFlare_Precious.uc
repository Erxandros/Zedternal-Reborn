class WMWeap_Pistol_DualFlare_Precious extends KFWeap_Pistol_DualFlare;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_Flare_Precious'
	MagazineCapacity(0)=18
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=216
	InstantHitDamage(ALTFIRE_FIREMODE)=50
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_FlareGun_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=50
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_FlareGun_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_DualFlare_Precious"
}
