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
	ZedSpawnRateFactor=0.925f
	WaveValueFactor=0.95f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Lethargic"

	Name="Default__WMSpecialWave_Lethargic"
}
