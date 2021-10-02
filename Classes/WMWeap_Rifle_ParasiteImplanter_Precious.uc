class WMWeap_Rifle_ParasiteImplanter_Precious extends KFWeap_Rifle_ParasiteImplanter;

defaultproperties
{
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=94 //20% increase (round up)
	MagazineCapacity(1)=150 //50% increase
	SeedAmmo=150 //50% increase
	InstantHitDamage(DEFAULT_FIREMODE)=344.0 //25% increase (round up)
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_ParasiteImplanterAlt_Precious'
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_ParasiteImplanter_Precious"
}
