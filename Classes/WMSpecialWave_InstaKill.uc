class WMSpecialWave_InstaKill extends WMSpecialWave;

function PostBeginPlay()
{
	SetTimer(4.f, true, NameOf(UpdateFleshpound));
}

function UpdateFleshpound()
{
	local KFPawn_ZedFleshpound KFM;
	
	foreach DynamicActors(class'KFPawn_ZedFleshpound', KFM)
	{
		KFM.SetEnraged(true);
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != none)
		InDamage = 9999999;
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (InstigatedBy != none && InstigatedBy.Pawn.GetTeamNum() != OwnerPawn.GetTeamNum())
		InDamage = 9999999;
}

defaultproperties
{
   Title="InstaKill"
   Description="But also for them!"
   zedSpawnRateFactor=1.100000
   waveValueFactor=0.600000
   doshFactor=1.500000
   bReplaceMonstertoAdd=true
   MonsterToAdd(0)=(MinWave=0,MaxWave=7,MinGr=1,MaxGr=5,MClass=Class'KFGameContent.KFPawn_ZedClot_Cyst')
   MonsterToAdd(1)=(MinWave=0,MaxWave=10,MinGr=1,MaxGr=6,MClass=Class'KFGameContent.KFPawn_ZedClot_Cyst')
   MonsterToAdd(2)=(MinWave=0,MaxWave=13,MinGr=1,MaxGr=6,MClass=Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
   MonsterToAdd(3)=(MinWave=2,MaxWave=999,MinGr=1,MaxGr=5,MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher')
   MonsterToAdd(4)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=2,MClass=Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
   MonsterToAdd(5)=(MinWave=5,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'KFGameContent.KFPawn_ZedFleshpound')
   MonsterToAdd(6)=(MinWave=9,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher')
   Name="Default__WMSpecialWave_InstaKill"
}