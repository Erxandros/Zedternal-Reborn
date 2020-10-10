class WMProj_Husk_Fireball_Suicide extends KFProj_Husk_Fireball;

simulated function Tick(float Delta)
{
	SetRotation(rotator(Velocity));
	super.Tick(Delta);
}

defaultproperties
{
	Physics=PHYS_Falling
	Speed=1200.0f
	MaxSpeed=1200.0f

	BurnDuration=2.0f
	BurnDamageInterval=0.5f

	Begin Object Name=ExploTemplate0
		Damage=13.0f
		DamageRadius=250.0f
	End Object

	Name="Default__WMProj_Husk_Fireball_Suicide"
}
