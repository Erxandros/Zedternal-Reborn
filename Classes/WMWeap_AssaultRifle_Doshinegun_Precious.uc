class WMWeap_AssaultRifle_Doshinegun_Precious extends WMWeap_AssaultRifle_Doshinegun;

defaultproperties
{
	MagazineCapacity(0)=30
	InstantHitDamage(ALTFIRE_FIREMODE)=75
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Dosh_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=75
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Dosh_Precious'
	DoshCost=28
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_Doshinegun_Precious"
}
