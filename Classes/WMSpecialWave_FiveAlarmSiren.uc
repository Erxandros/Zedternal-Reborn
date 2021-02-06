class WMSpecialWave_FiveAlarmSiren extends WMSpecialWave;

var float Defense;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(5.0f, False, NameOf(UpdateZed));
}

function UpdateZed()
{
	if (WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager) != None && WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList.Length > 0)
	{
		WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList[WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList.Length - 1].MClass[3] = class'KFGameContent.KFPawn_ZedSiren';
		WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList[WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList.Length - 1].MClass[2] = class'KFGameContent.KFPawn_ZedSiren';
		WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList[WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList.Length - 1].MClass[1] = class'KFGameContent.KFPawn_ZedSiren';
		WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList[WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList.Length - 1].MClass[0] = class'KFGameContent.KFPawn_ZedSiren';
	}
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage -= Round(float(DefaultDamage) * default.Defense);
}

defaultproperties
{
	Defense=0.3f
	zedSpawnRateFactor=1.35f
	waveValueFactor=0.5f
	doshFactor=2.0f

	Title="Five Alarm Siren"
	Description="Plug your ears!"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=class'KFGameContent.KFPawn_ZedSiren')
	MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=class'KFGameContent.KFPawn_ZedSiren')
	MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=3,MaxGr=6,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(4)=(MinWave=4,MaxWave=999,MinGr=6,MaxGr=12,MClass=class'KFGameContent.KFPawn_ZedSiren')
	MonsterToAdd(5)=(MinWave=7,MaxWave=999,MinGr=2,MaxGr=3,MClass=class'KFGameContent.KFPawn_ZedSiren')

	Name="Default__WMSpecialWave_FiveAlarmSiren"
}
