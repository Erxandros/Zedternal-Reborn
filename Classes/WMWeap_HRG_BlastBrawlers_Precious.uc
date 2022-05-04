class WMWeap_HRG_BlastBrawlers_Precious extends WMWeap_HRG_BlastBrawlers;

defaultproperties
{
	MagazineCapacity(0)=8
	AmmoPickupScale(0)=0.75
	SpareAmmoCapacity(0)=56
	InstantHitDamage(BASH_FIREMODE)=135
	InstantHitDamage(CUSTOM_FIREMODE)=53
	WeaponProjectiles(CUSTOM_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_BlastBrawlers_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=68
	InstantHitDamage(HEAVY_ATK_FIREMODE)=270
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_BlastBrawlers_Precious"
}
