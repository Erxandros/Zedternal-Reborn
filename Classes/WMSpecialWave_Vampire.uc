class WMSpecialWave_Vampire extends WMSpecialWave;

var float HealRecharge;
var int HealAmount;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(5.0f, False, NameOf(StartBleeding));
}

function StartBleeding()
{
	SetTimer(0.8f, True, NameOf(UpdateHuman));
}

function UpdateHuman()
{
	local KFPawn_Human KFP;

	foreach DynamicActors(class'KFPawn_Human', KFP)
	{
		if (KFP.Health > 1)
			--KFP.Health;
	}
}

static simulated function ModifyHealerRechargeTime(out float InRechargeTime, float DefaultRechargeTime)
{
	InRechargeTime = DefaultRechargeTime / (DefaultRechargeTime / InRechargeTime - default.HealRecharge);
}

static function AddVampireHealth(out int InHealth, int DefaultHealth, KFPlayerController KFPC, class<DamageType> DT)
{
	InHealth += default.HealAmount;
}

defaultproperties
{
	HealRecharge=0.5f
	HealAmount=5
	ZedSpawnRateFactor=1.1f

	Title="Vampire"
	Description="Everyone is a vampire!"

	Name="Default__WMSpecialWave_Vampire"
}
