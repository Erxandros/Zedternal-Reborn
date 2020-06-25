class WMSpecialWave_InstaKill extends WMSpecialWave;

var float ZedSpeed, PlayerSpeed;
var int Damage;

function PostBeginPlay()
{
	SetTimer(4.0f, true, NameOf(UpdateFleshpound));
	SetTimer(0.5f, true, NameOf(UpdateZedSpeed));
}

function UpdateFleshpound()
{
	local KFPawn_ZedFleshpound KFM;

	foreach DynamicActors(class'KFPawn_ZedFleshpound', KFM)
	{
		KFM.SetEnraged(true);
	}
}

function UpdateZedSpeed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFPawn_ZedFleshpound(KFM) == none)
			KFM.bIsSprinting = false;
		KFM.AdjustMovementSpeed(default.ZedSpeed);
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != none)
		InDamage = default.Damage;
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (InstigatedBy != none && InstigatedBy.Pawn.GetTeamNum() != OwnerPawn.GetTeamNum())
		InDamage = default.Damage;
}

static simulated function ModifySpeed( out float InSpeed, float DefaultSpeed, KFPawn OwnerPawn)
{
	InSpeed += DefaultSpeed * default.PlayerSpeed;
}

defaultproperties
{
	Title="InstaKill"
	Description="But also for them!"
	zedSpawnRateFactor=1.200000
	waveValueFactor=0.500000
	doshFactor=3.000000

	ZedSpeed=0.6875f
	PlayerSpeed=0.10f
	Damage=9999999

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
