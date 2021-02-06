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
	zedSpawnRateFactor=1.9f
	waveValueFactor=0.8f
	doshFactor=1.1f

	Title="The Horde"
	Description="Rush Hour!"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(4)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(5)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
	MonsterToAdd(6)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedStalker_NoDAR')

	Name="Default__WMSpecialWave_TheHorde"
}
