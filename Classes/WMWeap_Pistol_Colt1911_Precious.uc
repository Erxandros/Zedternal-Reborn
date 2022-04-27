class WMWeap_Pistol_Colt1911_Precious extends KFWeap_Pistol_Colt1911;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Pistol_DualColt1911_Precious'
	MagazineCapacity(0)=12
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=164
	InstantHitDamage(BASH_FIREMODE)=28
	InstantHitDamage(DEFAULT_FIREMODE)=63
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_PistolColt1911_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Colt1911_Precious"
}
