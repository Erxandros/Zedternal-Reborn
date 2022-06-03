class WMSpecialWave_Phoenix_Helper extends Info
	transient;

var float Delay;
var class<KFPawn_Monster> KFPM_Class;
var class<KFAIController> KFAI_Class;
var vector LastLocation;
var rotator LastRotation;
var KFGameReplicationInfo KFGRI;

function PostBeginPlay()
{
	super.PostBeginPlay();
	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
}

function StartReviveTimer()
{
	SetTimer(default.Delay, False, NameOf(ReviveZED));
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

					Destroy();
					return;
				}
			}

			NewKFPM.Destroy();
		}
	}

	Destroy();
}

defaultproperties
{
	Delay=1.5f

	Name="Default__WMSpecialWave_Phoenix_Helper"
}
