class WMWeap_HRG_SonicGun_Precious extends KFWeap_HRG_SonicGun;

defaultproperties
{
	MagazineCapacity(0)=18
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=116
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=157
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_SonicBlastUncharged_HRG_SonicGun_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_SonicGun_Precious"
}
