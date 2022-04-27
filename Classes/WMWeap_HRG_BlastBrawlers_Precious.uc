class WMWeap_HRG_BlastBrawlers_Precious extends WMWeap_HRG_BlastBrawlers;

defaultproperties
{
	MagazineCapacity(0)=6
	AmmoPickupScale(0)=0.75
	SpareAmmoCapacity(0)=48
	InstantHitDamage(BASH_FIREMODE)=125
	InstantHitDamage(CUSTOM_FIREMODE)=49
	WeaponProjectiles(CUSTOM_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_BlastBrawlers_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=63
	InstantHitDamage(HEAVY_ATK_FIREMODE)=250
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_BlastBrawlers_Precious"
}
