class WMWeap_HRG_Dragonbreath_Precious extends KFWeap_HRG_Dragonbreath;

defaultproperties
{
	MagazineCapacity(0)=8
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=84
	InstantHitDamage(ALTFIRE_FIREMODE)=38
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Pellet_HRG_Dragonbreath_Precious'
	InstantHitDamage(BASH_FIREMODE)=37
	InstantHitDamage(DEFAULT_FIREMODE)=38
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Pellet_HRG_Dragonbreath_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Dragonbreath_Precious"
}
