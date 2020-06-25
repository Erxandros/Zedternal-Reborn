class WMSpecialWave_Acceleration extends WMSpecialWave;

var float MaxTimeDilation;
var float delta;

function PostBeginPlay()
{
	SetTimer(5.f,true,nameof(UpdateWorld));
	super.PostBeginPlay();
}

function UpdateWorld()
{
	if (WorldInfo.TimeDilation >= 1 && WorldInfo.TimeDilation < MaxTimeDilation)
		WorldInfo.TimeDilation += delta;
	if (WorldInfo.TimeDilation > MaxTimeDilation)
		WorldInfo.TimeDilation = MaxTimeDilation;
}

event Destroyed()
{
	WorldInfo.TimeDilation = 1.f;
	super.Destroyed();
}

defaultproperties
{
	Title="Acceleration"
	Description="Time is collapsing!"
	MaxTimeDilation=2.000000
	delta=0.040000
	Name="Default__WMSpecialWave_Acceleration"
}
