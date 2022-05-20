class WMSpecialWave_Locked extends WMSpecialWave;

var float Rate;
var transient SeqAct_Toggle DoorToggle;

function PostBeginPlay()
{
	super.PostBeginPlay();
	CreateCloseDoorToggle();
	SetTimer(5.0f, False, NameOf(UpdateDoor));
}

function CreateCloseDoorToggle()
{
	if (DoorToggle == None)
	{
		DoorToggle = new class'Engine.SeqAct_Toggle';
	}

	if (DoorToggle != None)
	{
		DoorToggle.InputLinks[0].bHasImpulse = False;
		DoorToggle.InputLinks[1].bHasImpulse = True;
		DoorToggle.InputLinks[2].bHasImpulse = False;
	}
}

function CreateOpenDoorToggle()
{
	if (DoorToggle == None)
	{
		DoorToggle = new class'Engine.SeqAct_Toggle';
	}

	if (DoorToggle != None)
	{
		DoorToggle.InputLinks[0].bHasImpulse = True;
		DoorToggle.InputLinks[1].bHasImpulse = False;
		DoorToggle.InputLinks[2].bHasImpulse = False;
	}
}

function WaveEnded()
{
	local KFDoorActor KFD;

	foreach WorldInfo.AllActors(class'KFGame.KFDoorActor', KFD)
	{
		if (!KFD.bIsDestroyed)
			KFD.WeldableComponent.Weld(-KFD.MaxWeldIntegrity);
		else
			KFD.WeldableComponent.Repair(1.0f);
	}

	SetTimer(2.0f, False, NameOf(WaveEndedDelay));
}

function WaveEndedDelay()
{
	local KFDoorActor KFD;

	CreateOpenDoorToggle();
	foreach WorldInfo.AllActors(class'KFGame.KFDoorActor', KFD)
	{
		if (!KFD.bIsDoorOpen && KFD.WeldIntegrity <= 0)
			KFD.OnToggle(DoorToggle);
	}

	super.WaveEnded();
}

function UpdateDoor()
{
	local KFDoorActor KFD;

	CreateCloseDoorToggle();
	foreach WorldInfo.AllActors(class'KFGame.KFDoorActor', KFD)
	{
		if (KFD.bIsDestroyed)
		{
			KFD.WeldableComponent.Repair(1.0f);
		}

		if (KFD.bCanCloseDoor)
		{
			if (KFD.bIsDoorOpen)
				KFD.OnToggle(DoorToggle);
			KFD.WeldableComponent.Weld(KFD.MaxWeldIntegrity);
		}
	}
}

static simulated function ModifyWeldingRate(out float InFastenRate, float DefaultFastenRate, out float InUnfastenRate, float DefaultUnfastenRate)
{
	InFastenRate = InFastenRate * default.Rate;
	InUnfastenRate = InUnfastenRate * default.Rate;
}

defaultproperties
{
	Rate=0.7f
	ZedSpawnRateFactor=0.9f
	WaveValueFactor=0.7f
	DoshFactor=1.4f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Locked"

	Name="Default__WMSpecialWave_Locked"
}
