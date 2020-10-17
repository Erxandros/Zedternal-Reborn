class WMWeap_Blunt_Pulverizer_Precious extends KFWeap_Blunt_Pulverizer;

var float StartingDamage;

simulated event PreBeginPlay()
{
	super.PreBeginPlay();

	if (ExplosionTemplate != none)
	{
		ExplosionTemplate.Damage = 479.0; //25% increase (round up);
		ExplosionTemplate.DamageRadius = 480.0; //20% increase

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
	MagazineCapacity(0)=8 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=18  //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=182.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=25.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Blunt_Pulverizer_Precious"
}
