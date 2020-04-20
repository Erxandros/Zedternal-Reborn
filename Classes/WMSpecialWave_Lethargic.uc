class WMSpecialWave_Lethargic extends WMSpecialWave;

var float zedSpeedScale;

function PostBeginPlay()
{
	SetTimer(2.f,true,nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	local KFPawn_Monster KFM;
	
	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (!KFM.bMovesFastInZedTime)
			KFM.SetZedTimeSpeedScale(default.zedSpeedScale);
	}
}


defaultproperties
{
   Title="Lethargic"
   Description="They are faster during ZED times!"
   zedSpawnRateFactor=0.925000
   waveValueFactor=0.950000
   
   zedSpeedScale=1.0f
   
   Name="Default__WMSpecialWave_Lethargic"
}