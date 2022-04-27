class WMWeap_Rifle_MosinNagant_Precious extends KFWeap_Rifle_MosinNagant;

defaultproperties
{
	MagazineCapacity(0)=8
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=72
	InstantHitDamage(BASH_FIREMODE)=125
	InstantHitDamage(DEFAULT_FIREMODE)=313
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_MosinNagant_Precious'
	InstantHitDamage(HEAVY_ATK_FIREMODE)=63
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_MosinNagant_Precious"
}
