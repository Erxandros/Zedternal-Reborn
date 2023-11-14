class WMWeap_AssaultRifle_Doshinegun_Precious extends WMWeap_AssaultRifle_Doshinegun;

defaultproperties
{
	MagazineCapacity(0)=40
	InstantHitDamage(ALTFIRE_FIREMODE)=108
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Dosh_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=108
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Dosh_Precious'
	DoshCost=14
	Name="Default__WMWeap_AssaultRifle_Doshinegun_Precious"
}
