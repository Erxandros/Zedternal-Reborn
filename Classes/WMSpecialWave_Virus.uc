class WMSpecialWave_Virus extends WMSpecialWave;

var float Prob;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local KFPawn_Monster KFPM;

	KFPM = KFPawn_Monster(KilledPawn);
	if (Killer != None && KFPM != None && FRand() < default.Prob)
	{
		TriggerExplosion(KFPM, Killer);
	}
}

function TriggerExplosion(KFPawn ZedOwner, Controller Killer)
{
	local WMExplosion_Virus ExploActor;

	if (ZedOwner != None && Killer.Pawn != None)
	{
		ExploActor = ZedOwner.Spawn(class'ZedternalReborn.WMExplosion_Virus', Killer.Pawn, , ZedOwner.Location, rotator(vect(0, 0, 1)));
		if (ExploActor != None)
		{
			ExploActor.InstigatorController = Killer;
			ExploActor.Instigator = Killer.Pawn;
		}
	}
}

defaultproperties
{
	Prob=0.25f
	ZedSpawnRateFactor=0.95f
	WaveValueFactor=1.05f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Virus"

	Name="Default__WMSpecialWave_Virus"
}
