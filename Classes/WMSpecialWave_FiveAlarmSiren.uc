class WMSpecialWave_FiveAlarmSiren extends WMSpecialWave;

var float Defense;

function PostBeginPlay()
{
	SetTimer(5.f,false,nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	if (WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager) != none && WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList.Length > 0)
	{
		WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList[WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList.Length-1].MClass[3] = Class'KFGameContent.KFPawn_ZedSiren';
		WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList[WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList.Length-1].MClass[2] = Class'KFGameContent.KFPawn_ZedSiren';
		WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList[WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList.Length-1].MClass[1] = Class'KFGameContent.KFPawn_ZedSiren';
		WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList[WMAISpawnManager(WMGameInfo_Endless(WorldInfo.Game).SpawnManager).groupList.Length-1].MClass[0] = Class'KFGameContent.KFPawn_ZedSiren';
	}
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage -= Round(float(DefaultDamage) * default.Defense);
}

defaultproperties
{
   Title="Five Alarm Siren"
   Description="Plug your ears!"
   bReplaceMonstertoAdd=true
   zedSpawnRateFactor=1.350000
   waveValueFactor=0.500000
   doshFactor=2.000000
   MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=Class'KFGameContent.KFPawn_ZedSiren')
   MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=Class'KFGameContent.KFPawn_ZedSiren')
   MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=3,MaxGr=6,MClass=Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
   MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher')
   MonsterToAdd(4)=(MinWave=4,MaxWave=999,MinGr=6,MaxGr=12,MClass=Class'KFGameContent.KFPawn_ZedSiren')
   MonsterToAdd(5)=(MinWave=7,MaxWave=999,MinGr=2,MaxGr=3,MClass=Class'KFGameContent.KFPawn_ZedSiren')
   
   Defense=0.300000
   
   Name="Default__WMSpecialWave_FiveAlarmSiren"
}