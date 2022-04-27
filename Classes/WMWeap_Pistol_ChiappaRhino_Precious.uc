class WMWeap_Pistol_ChiappaRhino_Precious extends KFWeap_Pistol_ChiappaRhino;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Pistol_ChiappaRhinoDual_Precious'
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=137
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=94
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol_ChiappaRhino_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_ChiappaRhino_Precious"
}
