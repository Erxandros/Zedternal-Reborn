class WMSpecialWave_InstaKill extends WMSpecialWave;

var float PlayerSpeed, ZedSpeed;
var int Damage;

function PostBeginPlay()
{
	super.PostBeginPlay();

	SetTimer(4.0f, True, NameOf(UpdateFleshpound));
	SetTimer(0.5f, True, NameOf(UpdateZedSpeed));
}

function UpdateFleshpound()
{
	local KFPawn_ZedFleshpound KFM;

	foreach DynamicActors(class'KFPawn_ZedFleshpound', KFM)
	{
		KFM.SetEnraged(True);
	}
}

function UpdateZedSpeed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFPawn_ZedFleshpound(KFM) == None)
			KFM.bIsSprinting = False;
		KFM.AdjustMovementSpeed(default.ZedSpeed);
	}
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != None)
		InDamage = default.Damage;
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (InstigatedBy != None && InstigatedBy.Pawn.GetTeamNum() != OwnerPawn.GetTeamNum())
		InDamage = default.Damage;
}

static simulated function ModifySpeed(out float InSpeed, float DefaultSpeed, KFPawn OwnerPawn)
{
	InSpeed += DefaultSpeed * default.PlayerSpeed;
}

defaultproperties
{
	PlayerSpeed=0.10f
	ZedSpeed=0.6875f
	Damage=9999999
	ZedSpawnRateFactor=1.2f
	WaveValueFactor=0.5f
	DoshFactor=3.0f

	Title="InstaKill"
	Description="But also for them!"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=7,MinGr=1,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(1)=(MinWave=0,MaxWave=10,MinGr=1,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(2)=(MinWave=0,MaxWave=13,MinGr=1,MaxGr=6,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(3)=(MinWave=2,MaxWave=999,MinGr=1,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(4)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade')
	MonsterToAdd(5)=(MinWave=5,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'KFGameContent.KFPawn_ZedFleshpound')
	MonsterToAdd(6)=(MinWave=9,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')

	Name="Default__WMSpecialWave_InstaKill"
}
