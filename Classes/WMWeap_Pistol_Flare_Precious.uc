class WMWeap_Pistol_Flare_Precious extends KFWeap_Pistol_Flare;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Pistol_DualFlare_Precious'
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=224
	InstantHitDamage(BASH_FIREMODE)=28
	InstantHitDamage(DEFAULT_FIREMODE)=50
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_FlareGun_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Flare_Precious"
}
