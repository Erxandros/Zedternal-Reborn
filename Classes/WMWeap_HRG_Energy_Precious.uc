class WMWeap_HRG_Energy_Precious extends KFWeap_HRG_Energy;

defaultproperties
{
	MagazineCapacity(0)=23
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=144
	InstantHitDamage(ALTFIRE_FIREMODE)=150
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Energy_Secondary_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=100
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Energy_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Energy_Precious"
}
