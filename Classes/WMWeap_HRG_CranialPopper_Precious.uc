class WMWeap_HRG_CranialPopper_Precious extends KFWeap_HRG_CranialPopper;

defaultproperties
{
	MagazineCapacity(0)=14
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=157
	AmmoCost(ALTFIRE_FIREMODE)=50
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Grenade_HRG_CranialPopper_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=68
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_CranialPopper_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_CranialPopper_Precious"
}
