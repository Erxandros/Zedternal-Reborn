class WMSpecialWave_TheHorde extends WMSpecialWave;

var float DamageTakenFactor;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(1.0f, True, NameOf(UpdateZed));
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFPawn_ZedCrawler(KFM) == None && KFPawn_ZedStalker(KFM) == None)
			KFM.bIsSprinting = True;
	}
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage = InDamage * default.DamageTakenFactor;
}

defaultproperties
{
	DamageTakenFactor=0.9f
	ZedSpawnRateFactor=2.0f
	WaveValueFactor=0.8f
	DoshFactor=1.1f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_TheHorde"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=12,MinGr=2,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(1)=(MinWave=0,MaxWave=18,MinGr=2,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(2)=(MinWave=0,MaxWave=15,MinGr=2,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(3)=(MinWave=0,MaxWave=21,MinGr=2,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(4)=(MinWave=0,MaxWave=20,MinGr=1,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
	MonsterToAdd(5)=(MinWave=0,MaxWave=14,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(6)=(MinWave=0,MaxWave=16,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedStalker_NoDAR')

	MonsterToAdd(7)=(MinWave=10,MaxWave=999,MinGr=2,MaxGr=3,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(8)=(MinWave=16,MaxWave=999,MinGr=2,MaxGr=3,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(9)=(MinWave=17,MaxWave=999,MinGr=1,MaxGr=3,MClass=class'KFGameContent.KFPawn_ZedClot_AlphaKing')
	MonsterToAdd(10)=(MinWave=18,MaxWave=999,MinGr=1,MaxGr=3,MClass=class'ZedternalReborn.WMPawn_ZedGorefast_Omega')
	MonsterToAdd(11)=(MinWave=12,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Big')
	MonsterToAdd(12)=(MinWave=14,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedStalker_Omega')

	Name="Default__WMSpecialWave_TheHorde"
}
