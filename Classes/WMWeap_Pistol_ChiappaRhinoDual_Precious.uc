class WMWeap_Pistol_ChiappaRhinoDual_Precious extends KFWeap_Pistol_ChiappaRhinoDual;

defaultproperties
{
	SingleClass=Class'ZedternalReborn.WMWeap_Pistol_ChiappaRhino_Precious'
	MagazineCapacity(0)=18 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=130 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol_ChiappaRhino_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=88.0 //25% increase (round up)
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol_ChiappaRhino_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=88.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_ChiappaRhinoDual_Precious"
}
