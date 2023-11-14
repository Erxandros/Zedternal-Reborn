class WMWeap_Shotgun_S12_Precious extends KFWeap_Shotgun_S12;

defaultproperties
{
	MagazineCapacity(0)=20
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=182
	MagazineCapacity(1)=2
	AmmoPickupScale(1)=0.5
	SpareAmmoCapacity(1)=7
	InstantHitDamage(BASH_FIREMODE)=41
	InstantHitDamage(DEFAULT_FIREMODE)=38
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	Begin Object Name=ExploTemplate0
		Damage=270
		DamageRadius=1040
	End Object
	Name="Default__WMWeap_Shotgun_S12_Precious"
}
