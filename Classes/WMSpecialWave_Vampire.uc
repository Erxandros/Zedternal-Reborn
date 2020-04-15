class WMSpecialWave_Vampire extends WMSpecialWave;

var float healRecharge;
var int Amount;
var int HealZed, HealLargeZed;

function PostBeginPlay()
{	
	SetTimer(5.f,false,nameof(StartBleeding));
	super.PostBeginPlay();
}

function StartBleeding()
{	
	SetTimer(0.800000,true,nameof(UpdateHuman));
}

function UpdateHuman()
{
	local KFPawn_Human KFP;
	
	foreach DynamicActors(class'KFPawn_Human', KFP)
	{
		if (KFP.Health>1)
			KFP.Health -= 1;
	}
}

static simulated function ModifyHealerRechargeTime( out float InRechargeTime, float DefaultRechargeTime)
{
	InRechargeTime += DefaultRechargeTime * default.healRecharge;
}

static function AddVampireHealth( out int InHealth, int DefaultHealth, KFPlayerController KFPC, class<DamageType> DT )
{
	InHealth += default.Amount;
}

defaultproperties
{
   Title="Vampire"
   Description="Everyone is a vampire!"
   zedSpawnRateFactor=1.100000
   
   healRecharge = 0.500000
   Amount = 5;
   HealZed = 5;
   HealLargeZed = 10;
   
   Name="Default__WMSpecialWave_Vampire"
}
