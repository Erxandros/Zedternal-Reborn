class WMSpecialWave_CatchMe extends WMSpecialWave;

var float Speed;

function PostBeginPlay()
{
	local KFPawn_Human KFP;

	foreach DynamicActors(class'KFPawn_Human', KFP)
	{
		KFP.UpdateGroundSpeed();
	}
	SetTimer(1.f,true,nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		KFM.bIsSprinting = true;
	}
}

static simulated function ModifySpeed( out float InSpeed, float DefaultSpeed, KFPawn OwnerPawn)
{
	InSpeed += DefaultSpeed * default.Speed;
}

defaultproperties
{
	Title="Catch me if you can"
	Description="Run for your life!"
	zedSpawnRateFactor=1.150000
	bReplaceMonstertoAdd=true
	MonsterToAdd(0)=(MinWave=0,MaxWave=16,MinGr=1,MaxGr=5,MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(1)=(MinWave=0,MaxWave=18,MinGr=1,MaxGr=4,MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(2)=(MinWave=3,MaxWave=20,MinGr=1,MaxGr=5,MClass=Class'ZedternalReborn.WMPawn_ZedStalker_NoDAR')
	MonsterToAdd(3)=(MinWave=3,MaxWave=999,MinGr=1,MaxGr=2,MClass=Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
	MonsterToAdd(4)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
	MonsterToAdd(5)=(MinWave=0,MaxWave=18,MinGr=1,MaxGr=6,MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(6)=(MinWave=0,MaxWave=22,MinGr=1,MaxGr=6,MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(7)=(MinWave=3,MaxWave=17,MinGr=1,MaxGr=5,MClass=Class'ZedternalReborn.WMPawn_ZedStalker_NoDAR')
	MonsterToAdd(8)=(MinWave=3,MaxWave=999,MinGr=1,MaxGr=4,MClass=Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
	MonsterToAdd(9)=(MinWave=5,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'KFGameContent.KFPawn_ZedScrake')
	MonsterToAdd(10)=(MinWave=10,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'KFGameContent.KFPawn_ZedFleshpound')

	Speed=0.500000

	Name="Default__WMSpecialWave_CatchMe"
}
