class WMSpecialWave_Phoenix extends WMSpecialWave;

var float Prob;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local KFPawn_Monster KFPM;
	local WMSpecialWave_Phoenix_Helper PhoenixHelper;

	KFPM = KFPawn_Monster(KilledPawn);
	if (KFPM != None && KFPM.MyKFAIC != None && KFPM.LastHitZoneIndex != HZI_HEAD && !KFPM.IsHeadless() && FRand() < default.Prob)
	{
		PhoenixHelper = Spawn(class'ZedternalReborn.WMSpecialWave_Phoenix_Helper');
		if (PhoenixHelper != None)
		{
			PhoenixHelper.KFPM_Class = KFPM.Class;
			PhoenixHelper.KFAI_Class = KFPM.MyKFAIC.Class;
			PhoenixHelper.LastLocation = KFPM.Location;
			PhoenixHelper.LastRotation = KFPM.Rotation;
			PhoenixHelper.StartReviveTimer();
		}
	}
}

defaultproperties
{
	Prob=0.4f
	ZedSpawnRateFactor=0.95f
	WaveValueFactor=0.875f
	DoshFactor=0.875f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Phoenix"

	Name="Default__WMSpecialWave_Phoenix"
}
