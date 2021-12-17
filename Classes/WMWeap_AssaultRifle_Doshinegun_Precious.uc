class WMWeap_AssaultRifle_Doshinegun_Precious extends WMWeap_AssaultRifle_Doshinegun;

defaultproperties
{
	MagazineCapacity(0)=30 //50% increase
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Dosh_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=75.0 //25% increase
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Dosh_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=75.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DoshCost=28
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_Doshinegun_Precious"
}
