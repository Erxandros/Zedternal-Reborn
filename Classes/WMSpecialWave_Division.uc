class WMSpecialWave_Division extends WMSpecialWave;

var float SmallZedDamageGiven, SmallZedDamageTaken, SmallZedSize;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local KFPawn_Monster KFPM, newKFPM1, newKFPM2;

	KFPM = KFPawn_Monster(KilledPawn);
	if (Killer != none && KFPM != none && KFPM.IntendedBodyScale >= 0.65f)
	{
		if (Rand(2) == 1)
		{
			newKFPM1 = spawn(KFPM.Class,,,KFPM.Location + vect(100,0,0), KilledPawn.Rotation);
			newKFPM2 = spawn(KFPM.Class,,,KFPM.Location - vect(100,0,0), KilledPawn.Rotation);
		}
		else
		{
			newKFPM1 = spawn(KFPM.Class,,,KFPM.Location + vect(0,100,0), KilledPawn.Rotation);
			newKFPM2 = spawn(KFPM.Class,,,KFPM.Location - vect(0,100,0), KilledPawn.Rotation);
		}

		if (newKFPM1 != none)
			AjustNewZed(newKFPM1, KFPM.MyKFAIC.class);
		
		if (newKFPM2 != none)
			AjustNewZed(newKFPM2, KFPM.MyKFAIC.class);
	}
}

function AjustNewZed(KFPawn_Monster KFPM, class< KFAIController > KFAI)
{
	if (KFPM != none && KFAI != none)
	{
		KFPM.MyKFAIC = Spawn(KFAI);
		SetBodyChangeFlag(KFPM);
		KFPM.MyKFAIC.Possess(KFPM, false);
		KFPM.IntendedBodyScale = default.SmallZedSize;
		KFPM.UpdateBodyScale(KFPM.IntendedBodyScale);
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != none && MyKFPM.IntendedBodyScale == default.SmallZedSize)
		InDamage += Round(float(InDamage) * default.SmallZedDamageGiven);
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (KFPawn_Monster(InstigatedBy.Pawn) != none && KFPawn_Monster(InstigatedBy.Pawn).IntendedBodyScale == default.SmallZedSize)
		InDamage -= Round(float(InDamage) * default.SmallZedDamageTaken);
}

static simulated function bool ShouldKnockDownOnBump(KFPawn_Monster KFPM, KFPawn OwnerPawn)
{
	if (KFPM != none && KFPM.IntendedBodyScale == default.SmallZedSize)
		return true;
	else
		return false;
}

defaultproperties
{
	Title="Division"
	Description="Double the Troubles!"
	zedSpawnRateFactor=0.500000
	waveValueFactor=0.400000
	doshFactor=0.650000

	SmallZedDamageGiven=0.800000
	SmallZedDamageTaken=0.500000
	SmallZedSize=0.55

	Name="Default__WMSpecialWave_Division"
}
