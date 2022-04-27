class WMWeap_Blunt_MedicBat_Precious extends KFWeap_Blunt_MedicBat;

defaultproperties
{
	MagazineCapacity(0)=3
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=12
	InstantHitDamage(BASH_FIREMODE)=50
	AmmoCost(DEFAULT_FIREMODE)=32
	InstantHitDamage(DEFAULT_FIREMODE)=100
	InstantHitDamage(HEAVY_ATK_FIREMODE)=175
	Begin Object Name=HeavyAttackHealingExplosion
		Damage=282
		DamageRadius=600
	End Object
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Blunt_MedicBat_Precious"
}
