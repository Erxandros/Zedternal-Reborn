class WMSpecialWave_Virus extends WMSpecialWave;

var float prob;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local KFPawn_Monster KFPM;

	KFPM = KFPawn_Monster(KilledPawn);
	if (Killer != none && KFPM != none && FRand() < default.prob)
	{
		TriggerExplosion( KFPM, Killer );
	}
}

function TriggerExplosion( KFPawn ZedOwner, Controller Killer )
{
	local WMExplosion_Virus ExploActor;

	// Only living crawlers can explode
	if( ZedOwner != none && Killer.Pawn != none)
	{
		// Explode using the given template
		ExploActor = ZedOwner.Spawn( class'ZedternalReborn.WMExplosion_Virus', Killer.Pawn,, ZedOwner.Location, rotator(vect(0,0,1)) );
		if( ExploActor != none )
		{
			ExploActor.InstigatorController = Killer;
			ExploActor.Instigator = Killer.Pawn;
		}

		VirusExplosion(ZedOwner, Killer);
	}
}

reliable client function VirusExplosion( KFPawn ZedOwner, Controller Killer )
{
	local WMExplosion_Virus ExploActor;

	// Only living crawlers can explode
	if( ZedOwner != none && Killer.Pawn != none)
	{
		// Explode using the given template
		ExploActor = ZedOwner.Spawn( class'ZedternalReborn.WMExplosion_Virus', Killer.Pawn,, ZedOwner.Location, rotator(vect(0,0,1)) );
		if( ExploActor != none )
		{
			ExploActor.InstigatorController = Killer;
			ExploActor.Instigator = Killer.Pawn;
		}
	}
}

defaultproperties
{
	Title="Virus"
	Description="Level 4 containment!"
	zedSpawnRateFactor=0.950000
	waveValueFactor=1.050000

	prob=0.2500000

	Name="Default__WMSpecialWave_Virus"
}
