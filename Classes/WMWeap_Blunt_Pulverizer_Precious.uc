class WMWeap_Blunt_Pulverizer_Precious extends KFWeap_Blunt_Pulverizer;

var float StartingDamage;

simulated event PreBeginPlay()
{
	super.PreBeginPlay();

	if (ExplosionTemplate != None)
	{
		ExplosionTemplate.Damage = 518;
		ExplosionTemplate.DamageRadius = 520;

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
	MagazineCapacity(0)=10
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=21
	InstantHitDamage(BASH_FIREMODE)=27
	InstantHitDamage(DEFAULT_FIREMODE)=108
	InstantHitDamage(HEAVY_ATK_FIREMODE)=196
	Name="Default__WMWeap_Blunt_Pulverizer_Precious"
}
