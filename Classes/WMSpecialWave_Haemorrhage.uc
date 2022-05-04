class WMSpecialWave_Haemorrhage extends WMSpecialWave;

var float HealRecharge;
var int BleedTime;
var array<int> RemainTime;

function PostBeginPlay()
{
	local KFPawn_Human KFP;
	local byte Index;

	super.PostBeginPlay();

	Index = 0;
	foreach DynamicActors(class'KFPawn_Human', KFP)
	{
		++Index;
	}

	RemainTime.length = Index;

	SetTimer(1.0f, True, NameOf(UpdateHuman));
}

function UpdateHuman()
{
	local KFPawn_Human KFP;
	local byte Index;

	Index = 0;
	foreach DynamicActors(class'KFPawn_Human', KFP)
	{
		if (RemainTime[Index] > 0 && KFP.Health > 1 && KFP.Health < KFP.HealthMax)
			--KFP.Health;

		--RemainTime[Index];
		++Index;
	}
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local WMSpecialWave_Haemorrhage WMS;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		WMS = GetSpecialWaveObject(OwnerPawn.Controller.WorldInfo);

		if (WMS != None)
			WMS.AddBleedTime(KFPawn_Human(OwnerPawn));
	}
}

function AddBleedTime(KFPawn_Human KFP)
{
	local KFPawn_Human KFPTest;
	local byte Index;

	Index = 0;
	foreach DynamicActors(class'KFPawn_Human', KFPTest)
	{
		if (KFP == KFPTest)
		{
			RemainTime[Index] = default.BleedTime;
			return;
		}

		++Index;
	}
}

static simulated function ModifyHealerRechargeTime(out float InRechargeTime, float DefaultRechargeTime)
{
	InRechargeTime -= DefaultRechargeTime * default.HealRecharge;
}

static function WMSpecialWave_Haemorrhage GetSpecialWaveObject(WorldInfo WI)
{
	local WMSpecialWave_Haemorrhage WMS;

	foreach WI.DynamicActors(class'ZedternalReborn.WMSpecialWave_Haemorrhage', WMS)
	{
		return WMS;
	}
}

defaultproperties
{
	HealRecharge=0.3f
	BleedTime=20
	ZedSpawnRateFactor=0.9f

	Title="Haemorrhage"
	Description="Watch out for paper cuts!"

	Name="Default__WMSpecialWave_Haemorrhage"
}
