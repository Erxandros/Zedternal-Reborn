class WMSpecialWave_Locked extends WMSpecialWave;

var float Rate;

function PostBeginPlay()
{
	SetTimer(5.f,false,nameof(UpdateDoor));
	super.PostBeginPlay();
}

function WaveEnded()
{
	local KFDoorActor KFD;
	
	ForEach WorldInfo.AllActors(class'KFGame.KFDoorActor',KFD)
	{
		if (!KFD.bIsDestroyed)
			KFD.WeldIntegrity = 0;
	}
}

function UpdateDoor()
{
	local KFDoorActor KFD;
	
	ForEach WorldInfo.AllActors(class'KFGame.KFDoorActor',KFD)
	{
		KFD.ResetDoor();
		KFD.WeldIntegrity = KFD.MaxWeldIntegrity;
		if (KFD.bIsDoorOpen == true)
			CloseDoor(KFD);
	}
}

function CloseDoor(KFDoorActor Door)
{
	if( Door.bIsDestroyed || !Door.bLocalIsDoorOpen )
	{
	 	return;
	}

	// If door has been closed, it's dirty
	Door.bHasBeenDirtied = true;

	Door.bIsDoorOpen = false;
	Door.bForceNetUpdate = true;
	Door.bDoorMoveCompleted = false;

	// Local (non-replicated) open flag
	Door.bLocalIsDoorOpen = false;

	Door.SetTickIsDisabled(false);

	//if( MyNavMeshObstacle != none )
	//{
	//	MyNavMeshObstacle.SetEnabled(true);
	//}

	Door.MovementControl.SetSkelControlActive(false);

	if ( Door.DoorMechanism == EDM_Hinge )
	{
		Door.SetTimer(Door.OpenBlendTime * 0.65, false, nameof(Door.TryPushPawns));
	}
	else
	{
		Door.SetTimer(Door.OpenBlendTime * 0.5, false, nameof(Door.TryPushPawns));
	}
}

static simulated function ModifyWeldingRate( out float InFastenRate, float DefaultFastenRate, out float InUnfastenRate, float DefaultUnfastenRate)
{
	InFastenRate = InFastenRate*default.Rate;
	InUnfastenRate = InUnfastenRate*default.Rate;
}

defaultproperties
{
   Title="Locked"
   Description="It's a trap!"
   zedSpawnRateFactor=0.900000
   waveValueFactor=0.700000
   doshFactor=1.400000
   
   Rate = 0.700000
   
   Name="Default__WMSpecialWave_Locked"
}
