class WMSpecialWave_TheHorde extends WMSpecialWave;

var float Size, DamageTakenFactor;

function PostBeginPlay()
{
	SetTimer(1.f,true,nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	local KFPawn_Monster KFM;
	
	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFPawn_ZedCrawler(KFM) == none && KFPawn_ZedStalker(KFM) == none)
			KFM.bIsSprinting = true;
	}
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage = InDamage * default.DamageTakenFactor;
}

defaultproperties
{
   Title="The Horde"
   Description="Rush Hour!"
   zedSpawnRateFactor=1.900000
   waveValueFactor=0.800000
   doshFactor=1.100000
   
   DamageTakenFactor=0.900000
   
   bReplaceMonstertoAdd=true
   MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
   MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher')
   MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
   MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher')
   MonsterToAdd(4)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=2,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
   MonsterToAdd(5)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
   MonsterToAdd(6)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=2,MClass=Class'ZedternalReborn.WMPawn_ZedStalker_NoDAR')
   
   Name="Default__WMSpecialWave_TheHorde"
}