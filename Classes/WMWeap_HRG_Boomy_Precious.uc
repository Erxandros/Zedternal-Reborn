class WMWeap_HRG_Boomy_Precious extends KFWeap_HRG_Boomy;

defaultproperties
{
	MagazineCapacity(0)=36
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=231
	InstantHitDamage(ALTFIRE_FIREMODE)=38
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Boomy_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=38
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Boomy_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Boomy_Precious"
}
