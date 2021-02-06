class WMSpecialWave_Locked extends WMSpecialWave;

var float Rate;
var transient SeqAct_Toggle CloseDoorToggle;

function PostBeginPlay()
{
	super.PostBeginPlay();
	CreateDoorToggle();
	SetTimer(5.0f, False, NameOf(UpdateDoor));
}

function CreateDoorToggle()
{
	if (CloseDoorToggle == None)
	{
		CloseDoorToggle = new class'Engine.SeqAct_Toggle';
		if (CloseDoorToggle != None)
		{
			CloseDoorToggle.InputLinks[0].bHasImpulse = False;
			CloseDoorToggle.InputLinks[1].bHasImpulse = True;
			CloseDoorToggle.InputLinks[2].bHasImpulse = False;
		}
	}
}

function WaveEnded()
{
	local KFDoorActor KFD;

	foreach WorldInfo.AllActors(class'KFGame.KFDoorActor', KFD)
	{
		if (!KFD.bIsDestroyed)
			KFD.WeldIntegrity = 0;
	}

	super.WaveEnded();
}

function UpdateDoor()
{
	local KFDoorActor KFD;

	CreateDoorToggle();
	foreach WorldInfo.AllActors(class'KFGame.KFDoorActor', KFD)
	{
		KFD.ResetDoor();
		if (KFD.bIsDoorOpen == True)
			KFD.OnToggle(CloseDoorToggle);
		KFD.WeldableComponent.Weld(KFD.MaxWeldIntegrity);
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
	zedSpawnRateFactor=0.9f
	waveValueFactor=0.7f
	doshFactor=1.4f

	Title="Locked"
	Description="It's a trap!"

	Name="Default__WMSpecialWave_Locked"
}
