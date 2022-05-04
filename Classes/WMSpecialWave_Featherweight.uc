class WMSpecialWave_Featherweight extends WMSpecialWave;

var float GlobalDeflationRate, InflationDeathGravity, InflationExplosionTimer, ZeroHealthInflation;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(1.0f, True, NameOf(UpdateZed));
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (!KFM.bUseDamageInflation)
		{
			KFM.bUseDamageInflation = True;
			KFM.ZeroHealthInflation = default.ZeroHealthInflation;
			KFM.DamageDeflationRate = default.GlobalDeflationRate;
			KFM.InflationExplosionTimer = default.InflationExplosionTimer;
			KFM.InflateDeathGravity = default.InflationDeathGravity;
		}
	}
}

defaultproperties
{
	GlobalDeflationRate=0.0f
	InflationDeathGravity=-0.003f
	InflationExplosionTimer=100.0f
	ZeroHealthInflation=1.0f
	ZedSpawnRateFactor=0.9f

	Title="Featherweight"
	Description="Dead bodies are floating!"

	Name="Default__WMSpecialWave_Featherweight"
}
