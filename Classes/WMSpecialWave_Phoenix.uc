class WMSpecialWave_Phoenix extends WMSpecialWave;

var float prob, delay;
var class< KFPawn_Monster > KFPM_class;
var class< KFAIController > KFAI_class;
var vector lastLocation;
var rotator lastRotation;
var KFGameReplicationInfo KFGRI;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local KFPawn_Monster KFPM;
	
	KFPM = KFPawn_Monster(KilledPawn);
	if (KFPM != none && FRand() < default.prob && !IsTimerActive(nameof(ReviveZED)))
	{
		KFPM_class = KFPM.Class;
		KFAI_class = KFPM.MyKFAIC.class;
		lastLocation = KFPM.Location;
		lastRotation = KFPM.Rotation;
		KFGRI = KFGameReplicationInfo(Killer.WorldInfo.GRI);
		SetTimer(default.delay, false, nameof(ReviveZED));
	}		
	
}
	
function ReviveZED()
{
	local KFPawn_Monster newKFPM;
	
	if (KFPM_class != none && KFAI_class != none && KFGRI != none && KFGRI.AIRemaining > 0)
	{
		newKFPM = spawn(KFPM_class,,,lastLocation, lastRotation);
		if (newKFPM != none)
		{
			newKFPM.MyKFAIC = Spawn(KFAI_class);
			newKFPM.MyKFAIC.Possess(newKFPM, false);
			if (newKFPM.CanDoSpecialMove( SM_Knockdown ))
				newKFPM.Knockdown(vect(0,0,0), vect(1,1,1), newKFPM.Location, 1000, 100);
			
			KFGRI.AIRemaining += 1;
			
			// effects
			Spawn(class'ZedternalReborn.WMFX_Phoenix',,, lastLocation, newKFPM.Rotation,,true);
			Spawn(class'ZedternalReborn.WMFX_PhoenixB',,, lastLocation, newKFPM.Rotation,,true);
		}
	}
}


defaultproperties
{
   Title="Phoenix"
   Description="They revive from their ashes!"
   zedSpawnRateFactor=0.950000
   waveValueFactor=0.875000
   doshFactor=0.875000
   
   prob=0.200000
   delay=2.000000
   
   Name="Default__WMSpecialWave_Phoenix"
}