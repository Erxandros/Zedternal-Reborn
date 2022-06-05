class WMWeap_Rifle_ParasiteImplanter_Precious extends KFWeap_Rifle_ParasiteImplanter;

defaultproperties
{
	MagazineCapacity(0)=12
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=110
	AmmoCost(ALTFIRE_FIREMODE)=25
	InstantHitDamage(ALTFIRE_FIREMODE)=2
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_ParasiteImplanterAlt_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=372
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_ParasiteImplanter_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_ParasiteImplanter_Precious"
}
