class WMSpecialWave_Phoenix extends WMSpecialWave;

var float Delay, Prob;
var class<KFPawn_Monster> KFPM_Class;
var class<KFAIController> KFAI_Class;
var vector LastLocation;
var rotator LastRotation;
var KFGameReplicationInfo KFGRI;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local KFPawn_Monster KFPM;

	KFPM = KFPawn_Monster(KilledPawn);
	if (KFPM != None && KFPM.MyKFAIC != None && FRand() < default.Prob && !IsTimerActive(NameOf(ReviveZED)))
	{
		KFPM_Class = KFPM.Class;
		KFAI_Class = KFPM.MyKFAIC.Class;
		LastLocation = KFPM.Location;
		LastRotation = KFPM.Rotation;
		KFGRI = KFGameReplicationInfo(Killer.WorldInfo.GRI);
		SetTimer(default.Delay, False, NameOf(ReviveZED));
	}
}

function ReviveZED()
{
	local KFPawn_Monster NewKFPM;
	local KFAIController NewKFAIC;

	if (KFPM_Class != None && KFAI_Class != None && KFGRI != None && KFGRI.AIRemaining > 0)
	{
		NewKFPM = Spawn(KFPM_Class, , , LastLocation, LastRotation);
		if (NewKFPM != None)
		{
			NewKFAIC = Spawn(KFAI_Class);
			if (NewKFAIC != None)
			{
				NewKFAIC.Possess(NewKFPM, False);
				if (NewKFPM.IsAliveAndWell())
				{
					if (NewKFPM.CanDoSpecialMove(SM_Knockdown))
						NewKFPM.Knockdown(vect(0, 0, 0), vect(1, 1, 1), NewKFPM.Location, 1000, 100);

					// effects
					Spawn(class'ZedternalReborn.WMFX_Phoenix', , , LastLocation, NewKFPM.Rotation, ,True);
					Spawn(class'ZedternalReborn.WMFX_PhoenixB', , , LastLocation, NewKFPM.Rotation, ,True);

					return;
				}
			}

			NewKFPM.Destroy();
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

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Phoenix"

	Name="Default__WMSpecialWave_Phoenix"
}
