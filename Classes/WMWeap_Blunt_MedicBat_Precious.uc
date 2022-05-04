class WMWeap_Blunt_MedicBat_Precious extends KFWeap_Blunt_MedicBat;

defaultproperties
{
	MagazineCapacity(0)=4
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=14
	InstantHitDamage(BASH_FIREMODE)=54
	AmmoCost(DEFAULT_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=108
	InstantHitDamage(HEAVY_ATK_FIREMODE)=189
	Begin Object Name=HeavyAttackHealingExplosion
		Damage=304
		DamageRadius=650
	End Object
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Blunt_MedicBat_Precious"
}
