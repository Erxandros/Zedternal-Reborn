class WMSpecialWave_CatchMe extends WMSpecialWave;

var float Speed;

function PostBeginPlay()
{
	local KFPawn_Human KFP;

	super.PostBeginPlay();
	foreach DynamicActors(class'KFPawn_Human', KFP)
	{
		KFP.UpdateGroundSpeed();
	}
	SetTimer(1.0f, True, NameOf(UpdateZed));
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		KFM.bIsSprinting = True;
	}
}

static simulated function ModifySpeed(out float InSpeed, float DefaultSpeed, KFPawn OwnerPawn)
{
	InSpeed += DefaultSpeed * default.Speed;
}

defaultproperties
{
	Speed=0.5f
	ZedSpawnRateFactor=1.25f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_CatchMe"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=14,MinGr=1,MaxGr=4,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(1)=(MinWave=0,MaxWave=16,MinGr=1,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(2)=(MinWave=0,MaxWave=18,MinGr=1,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(3)=(MinWave=0,MaxWave=22,MinGr=1,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(4)=(MinWave=3,MaxWave=17,MinGr=1,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedStalker_NoDAR')
	MonsterToAdd(5)=(MinWave=3,MaxWave=20,MinGr=1,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedStalker_NoDAR')
	MonsterToAdd(6)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
	MonsterToAdd(7)=(MinWave=3,MaxWave=999,MinGr=1,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
	MonsterToAdd(8)=(MinWave=3,MaxWave=999,MinGr=1,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
	MonsterToAdd(9)=(MinWave=5,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'KFGameContent.KFPawn_ZedScrake')
	MonsterToAdd(10)=(MinWave=12,MaxWave=999,MinGr=1,MaxGr=3,MClass=class'KFGameContent.KFPawn_ZedScrake')
	MonsterToAdd(11)=(MinWave=8,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedScrake_Tiny')
	MonsterToAdd(12)=(MinWave=10,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'KFGameContent.KFPawn_ZedFleshpound')
	MonsterToAdd(13)=(MinWave=18,MaxWave=999,MinGr=1,MaxGr=3,MClass=class'KFGameContent.KFPawn_ZedFleshpound')

	Name="Default__WMSpecialWave_CatchMe"
}
