class WMSpecialWave_Regeneration extends WMSpecialWave;

var float HealRecharge, RegenTimer;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(RegenTimer, True, NameOf(UpdateHuman));
}

function UpdateHuman()
{
	local KFPawn_Human KFP;

	foreach DynamicActors(class'KFPawn_Human', KFP)
	{
		if (KFP.Health > 0 && KFP.Health < KFP.HealthMax)
			++KFP.Health;
	}
}

static simulated function ModifyHealerRechargeTime(out float InRechargeTime, float DefaultRechargeTime)
{
	InRechargeTime = DefaultRechargeTime / (DefaultRechargeTime / InRechargeTime + default.HealRecharge);
}

defaultproperties
{
	HealRecharge=0.3f
	RegenTimer=0.3f
	ZedSpawnRateFactor=1.1f

	Title="Regeneration"
	Description="You feel better!"

	Name="Default__WMSpecialWave_Regeneration"
}
