class WMWeap_HRG_Stunner_Precious extends KFWeap_HRG_Stunner;

defaultproperties
{
	MagazineCapacity(0)=38
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=270
	InstantHitDamage(ALTFIRE_FIREMODE)=25
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Stunner_Alt_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=75
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Stunner_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Stunner_Precious"
}
