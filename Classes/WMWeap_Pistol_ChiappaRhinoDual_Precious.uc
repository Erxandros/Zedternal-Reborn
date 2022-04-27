class WMWeap_Pistol_ChiappaRhinoDual_Precious extends KFWeap_Pistol_ChiappaRhinoDual;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Pistol_ChiappaRhino_Precious'
	MagazineCapacity(0)=18
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=130
	InstantHitDamage(ALTFIRE_FIREMODE)=94
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol_ChiappaRhino_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=94
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol_ChiappaRhino_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_ChiappaRhinoDual_Precious"
}
