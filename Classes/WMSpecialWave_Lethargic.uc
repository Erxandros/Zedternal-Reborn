class WMSpecialWave_Lethargic extends WMSpecialWave;

var float ZedSpeedScale;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(2.0f, True, NameOf(UpdateZed));
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (!KFM.bMovesFastInZedTime)
			KFM.SetZedTimeSpeedScale(default.ZedSpeedScale);
	}
}

defaultproperties
{
	ZedSpeedScale=1.0f
	zedSpawnRateFactor=0.925f
	waveValueFactor=0.95f

	Title="Lethargic"
	Description="They are faster during ZED times!"

	Name="Default__WMSpecialWave_Lethargic"
}
