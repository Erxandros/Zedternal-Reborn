class WMSpecialWave_Featherweight extends WMSpecialWave;

var float ZeroHealthInflation, InflationDeathGravity, InflationExplosionTimer, GlobalDeflationRate;
var float DeathGravity;

function PostBeginPlay()
{
	SetTimer(1.f,true,nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	local KFPawn_Monster KFM;
	
	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (!KFM.bUseDamageInflation)
		{
			KFM.bUseDamageInflation = true;
			KFM.ZeroHealthInflation = default.ZeroHealthInflation;
			KFM.DamageDeflationRate = default.GlobalDeflationRate;
			//KFM.bDisableGoreMeshWhileAlive = true;
			KFM.InflationExplosionTimer = default.InflationExplosionTimer;
			KFM.InflateDeathGravity = default.InflationDeathGravity;
		}
	}
}

defaultproperties
{
   Title="Featherweight"
   Description="Dead bodies are floating!"
   zedSpawnRateFactor=0.900000
   waveValueFactor=1.000000
   
   ZeroHealthInflation=1.000000
   InflationDeathGravity=-0.003000
   InflationExplosionTimer=100.00000
   GlobalDeflationRate=0.000000
   
   Name="Default__WMSpecialWave_Featherweight"
}