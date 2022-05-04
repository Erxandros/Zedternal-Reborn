class WMWeap_HRG_SonicGun_Precious extends KFWeap_HRG_SonicGun;

defaultproperties
{
	MagazineCapacity(0)=24
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=135
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=169
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_SonicBlastUncharged_HRG_SonicGun_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_SonicGun_Precious"
}
