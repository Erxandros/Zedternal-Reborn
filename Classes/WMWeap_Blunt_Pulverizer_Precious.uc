class WMWeap_Blunt_Pulverizer_Precious extends KFWeap_Blunt_Pulverizer;

var float StartingDamage;

simulated event PreBeginPlay()
{
	super.PreBeginPlay();

	if (ExplosionTemplate != None)
	{
		ExplosionTemplate.Damage = 479;
		ExplosionTemplate.DamageRadius = 480;

		StartingDamage = ExplosionTemplate.Damage;
		StartingDamageRadius = ExplosionTemplate.DamageRadius;
	}
}

simulated protected function PrepareExplosionTemplate()
{
	super.PrepareExplosionTemplate();

	if (!bWasTimeDilated)
		ExplosionTemplate.Damage = StartingDamage;
}

defaultproperties
{
	MagazineCapacity(0)=8
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=18
	InstantHitDamage(BASH_FIREMODE)=25
	InstantHitDamage(DEFAULT_FIREMODE)=100
	InstantHitDamage(HEAVY_ATK_FIREMODE)=182
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Blunt_Pulverizer_Precious"
}
