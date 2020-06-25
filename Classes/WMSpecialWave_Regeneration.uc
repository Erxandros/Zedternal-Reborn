class WMSpecialWave_Regeneration extends WMSpecialWave;

var float healRecharge;
var float regenTimer;

function PostBeginPlay()
{
	SetTimer(regenTimer,true,nameof(UpdateHuman));
	super.PostBeginPlay();
}

function UpdateHuman()
{
	local KFPawn_Human KFP;

	foreach DynamicActors(class'KFPawn_Human', KFP)
	{
		if (KFP.Health>1 && KFP.Health<KFP.HealthMax)
			KFP.Health += 1;
	}
}

static simulated function ModifyHealerRechargeTime( out float InRechargeTime, float DefaultRechargeTime)
{
	InRechargeTime -= DefaultRechargeTime * default.healRecharge;
}

static function WMSpecialWave_Haemorrhage GetSpecialWaveObject(WorldInfo WI)
{
	local WMSpecialWave_Haemorrhage WMS;

	foreach WI.DynamicActors(class'ZedternalReborn.WMSpecialWave_Haemorrhage',WMS)
	{
		return WMS;
	}
}

defaultproperties
{
	Title="Regeneration"
	Description="You feel better!"
	zedSpawnRateFactor=1.100000
	waveValueFactor=1.000000
	healRecharge=0.300000
	regenTimer=0.300000

	Name="Default__WMSpecialWave_Regeneration"
}
