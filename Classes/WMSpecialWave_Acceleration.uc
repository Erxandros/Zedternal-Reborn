class WMSpecialWave_Acceleration extends WMSpecialWave;

var float Delta, MaxTimeDilation;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(5.0f, True, NameOf(UpdateWorld));
}

function UpdateWorld()
{
	if (WorldInfo.TimeDilation >= 1 && WorldInfo.TimeDilation < MaxTimeDilation)
		WorldInfo.TimeDilation += Delta;

	if (WorldInfo.TimeDilation > MaxTimeDilation)
		WorldInfo.TimeDilation = MaxTimeDilation;
}

event Destroyed()
{
	WorldInfo.TimeDilation = 1.0f;
	super.Destroyed();
}

defaultproperties
{
	MaxTimeDilation=2.0f
	Delta=0.04f

	Title="Acceleration"
	Description="Time is collapsing!"

	Name="Default__WMSpecialWave_Acceleration"
}
