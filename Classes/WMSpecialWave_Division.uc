class WMSpecialWave_Division extends WMSpecialWave;

var float SmallZedDamageGiven, SmallZedDamageTaken, SmallZedSize;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local KFPawn_Monster KFPM, newKFPM1, newKFPM2;

	KFPM = KFPawn_Monster(KilledPawn);
	if (Killer != None && KFPM != None && KFPM.MyKFAIC != None &&
		(KFPM.IntendedBodyScale >= class'ZedternalReborn.WMSpecialWave_TinyTerror'.default.ZedScale || !CheckZedBodyChange(KFPM)))
	{
		if (Rand(2) == 1)
		{
			newKFPM1 = spawn(KFPM.class,,,KFPM.Location + vect(100,0,0), KilledPawn.Rotation);
			newKFPM2 = spawn(KFPM.class,,,KFPM.Location - vect(100,0,0), KilledPawn.Rotation);
		}
		else
		{
			newKFPM1 = spawn(KFPM.class,,,KFPM.Location + vect(0,100,0), KilledPawn.Rotation);
			newKFPM2 = spawn(KFPM.class,,,KFPM.Location - vect(0,100,0), KilledPawn.Rotation);
		}

		if (newKFPM1 != None)
			AjustNewZed(newKFPM1, KFPM.MyKFAIC.class);

		if (newKFPM2 != None)
			AjustNewZed(newKFPM2, KFPM.MyKFAIC.class);
	}
}

function AjustNewZed(KFPawn_Monster KFPM, class<KFAIController> KFAI)
{
	if (KFPM != None && KFAI != None)
	{
		KFPM.MyKFAIC = Spawn(KFAI);
		SetBodyChangeFlag(KFPM);
		KFPM.MyKFAIC.Possess(KFPM, False);
		KFPM.IntendedBodyScale = default.SmallZedSize;
		KFPM.UpdateBodyScale(KFPM.IntendedBodyScale);
	}
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != None && MyKFPM.IntendedBodyScale == default.SmallZedSize)
		InDamage += Round(float(InDamage) * default.SmallZedDamageGiven);
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (KFPawn_Monster(InstigatedBy.Pawn) != None && KFPawn_Monster(InstigatedBy.Pawn).IntendedBodyScale == default.SmallZedSize)
		InDamage -= Round(float(InDamage) * default.SmallZedDamageTaken);
}

static simulated function bool ShouldKnockDownOnBump(KFPawn_Monster KFPM, KFPawn OwnerPawn)
{
	if (KFPM != None && KFPM.IntendedBodyScale == default.SmallZedSize)
		return True;
	else
		return False;
}

defaultproperties
{
	SmallZedDamageGiven=0.8f
	SmallZedDamageTaken=0.5f
	SmallZedSize=0.55f
	ZedSpawnRateFactor=0.5f
	WaveValueFactor=0.4f
	DoshFactor=0.65f

	Title="Division"
	Description="Double the Troubles!"

	Name="Default__WMSpecialWave_Division"
}
