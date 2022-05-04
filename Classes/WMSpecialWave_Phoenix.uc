class WMSpecialWave_Phoenix extends WMSpecialWave;

var float Delay, Prob;
var class<KFPawn_Monster> KFPM_class;
var class<KFAIController> KFAI_class;
var vector LastLocation;
var rotator LastRotation;
var KFGameReplicationInfo KFGRI;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local KFPawn_Monster KFPM;

	KFPM = KFPawn_Monster(KilledPawn);
	if (KFPM != None && FRand() < default.Prob && !IsTimerActive(NameOf(ReviveZED)))
	{
		KFPM_class = KFPM.class;
		KFAI_class = KFPM.MyKFAIC.class;
		LastLocation = KFPM.Location;
		LastRotation = KFPM.Rotation;
		KFGRI = KFGameReplicationInfo(Killer.WorldInfo.GRI);
		SetTimer(default.Delay, False, NameOf(ReviveZED));
	}
}

function ReviveZED()
{
	local KFPawn_Monster NewKFPM;

	if (KFPM_class != None && KFAI_class != None && KFGRI != None && KFGRI.AIRemaining > 0)
	{
		NewKFPM = Spawn(KFPM_class, , , LastLocation, LastRotation);
		if (NewKFPM != None)
		{
			NewKFPM.MyKFAIC = Spawn(KFAI_class);
			NewKFPM.MyKFAIC.Possess(NewKFPM, False);
			if (NewKFPM.CanDoSpecialMove(SM_Knockdown))
				NewKFPM.Knockdown(vect(0, 0, 0), vect(1, 1, 1), NewKFPM.Location, 1000, 100);

			// effects
			Spawn(class'ZedternalReborn.WMFX_Phoenix',,, LastLocation, NewKFPM.Rotation,,True);
			Spawn(class'ZedternalReborn.WMFX_PhoenixB',,, LastLocation, NewKFPM.Rotation,,True);
		}
	}
}

defaultproperties
{
	Delay=2.0f
	Prob=0.2f
	ZedSpawnRateFactor=0.95f
	WaveValueFactor=0.875f
	DoshFactor=0.875f

	Title="Phoenix"
	Description="They revive from their ashes!"

	Name="Default__WMSpecialWave_Phoenix"
}
