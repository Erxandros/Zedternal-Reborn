class WMWeap_HRG_Stunner_Precious extends KFWeap_HRG_Stunner;

defaultproperties
{
	MagazineCapacity(0)=50
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=315
	InstantHitDamage(ALTFIRE_FIREMODE)=27
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Stunner_Alt_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=108
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Stunner_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Stunner_Precious"
}
