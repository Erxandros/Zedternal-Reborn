class WMSpecialWave_FiveAlarmSiren extends WMSpecialWave;

var float Defense;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(5.0f, False, NameOf(UpdateZed));
}

function UpdateZed()
{
	local array< class<KFPawn_Monster> > Zeds;

	Zeds.AddItem(class'KFGameContent.KFPawn_ZedSiren');
	Zeds.AddItem(class'KFGameContent.KFPawn_ZedSiren');
	Zeds.AddItem(class'KFGameContent.KFPawn_ZedSiren');
	Zeds.AddItem(class'KFGameContent.KFPawn_ZedSiren');

	AddNewZedGroupToSpawnList(MaxInt, Zeds);
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage -= Round(float(DefaultDamage) * default.Defense);
}

defaultproperties
{
	Defense=0.3f
	ZedSpawnRateFactor=1.35f
	WaveValueFactor=0.5f
	DoshFactor=2.0f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_FiveAlarmSiren"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=class'KFGameContent.KFPawn_ZedSiren')
	MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=class'KFGameContent.KFPawn_ZedSiren')
	MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=3,MaxGr=6,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(4)=(MinWave=4,MaxWave=999,MinGr=6,MaxGr=12,MClass=class'KFGameContent.KFPawn_ZedSiren')
	MonsterToAdd(5)=(MinWave=7,MaxWave=999,MinGr=2,MaxGr=3,MClass=class'KFGameContent.KFPawn_ZedSiren')

	Name="Default__WMSpecialWave_FiveAlarmSiren"
}
