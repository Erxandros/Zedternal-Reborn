class WMWeap_Rifle_HRGIncision_Precious extends KFWeap_Rifle_HRGIncision;

defaultproperties
{
	MagazineCapacity(0)=2
	AmmoPickupScale(0)=1.5
	SpareAmmoCapacity(0)=47
	AmmoCost(ALTFIRE_FIREMODE)=40
	InstantHitDamage(ALTFIRE_FIREMODE)=94
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRGIncisionHeal_Precious'
	InstantHitDamage(BASH_FIREMODE)=38
	InstantHitDamage(DEFAULT_FIREMODE)=500
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRGIncisionHurt_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_HRGIncision_Precious"
}
