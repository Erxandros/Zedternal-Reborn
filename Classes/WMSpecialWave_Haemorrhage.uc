class WMSpecialWave_Haemorrhage extends WMSpecialWave;

var float healRecharge;
var array< int > remainTime;
var int bleedTime;

function PostBeginPlay()
{
	local KFPawn_Human KFP;
	local int Index;

	foreach DynamicActors(class'KFPawn_Human', KFP)
	{
		Index ++;
	}
	
	remainTime.length = Index;
	
	SetTimer(1.f,true,nameof(UpdateHuman));
	super.PostBeginPlay();
}

function UpdateHuman()
{
	local KFPawn_Human KFP;
	local int Index;
	
	Index = 0;
	foreach DynamicActors(class'KFPawn_Human', KFP)
	{
		if (remainTime[Index] > 0 && KFP.Health>1 && KFP.Health<KFP.HealthMax)
			KFP.Health -= 1;
		
		remainTime[Index] -= 1;
		Index ++;
	}
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local WMSpecialWave_Haemorrhage WMS;
	
	if (KFPawn_Human(OwnerPawn) != none)
	{
		WMS = GetSpecialWaveObject(OwnerPawn.Controller.WorldInfo);
		
		if (WMS != none)
			WMS.AddBleedTime(KFPawn_Human(OwnerPawn));
	}
}

function AddBleedTime(KFPawn_Human KFP)
{
	local KFPawn_Human KFP_test;
	local int Index;
	
	Index = 0;
	foreach DynamicActors(class'KFPawn_Human', KFP_test)
	{
		if (KFP == KFP_test)
		{
			remainTime[Index] = default.bleedTime;
			return;
		}
		
		Index ++;
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
   Title="Haemorrhage"
   Description="Watch out for paper cuts!"
   zedSpawnRateFactor=0.900000
   waveValueFactor=1.000000
   healRecharge = 0.300000
   bleedTime = 20
   
   Name="Default__WMSpecialWave_Hemoragie"
}
