class WMSpecialWave_UpUpDecay extends WMSpecialWave;

var float ZeroHealthInflation, InflationDeathGravity, InflationExplosionTimer, GlobalDeflationRate;
var float Damage, DamageBloat;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (KFPawn_ZedBloat(MyKFPM) != none)
		InDamage += Round(float(DefaultDamage) * default.DamageBloat);
	else
		InDamage += Round(float(DefaultDamage) * default.Damage);
}

function PostBeginPlay()
{
	SetTimer(2.f,true,nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (!KFM.bUseDamageInflation)
		{
			KFM.bUseDamageInflation = true;
			KFM.ZeroHealthInflation = default.ZeroHealthInflation;
			KFM.DamageDeflationRate = default.GlobalDeflationRate;
			KFM.bDisableGoreMeshWhileAlive = true;
			KFM.InflationExplosionTimer = default.InflationExplosionTimer;
			KFM.InflateDeathGravity = default.InflationDeathGravity;
		}
	}
}

defaultproperties
{
	Title="Up, Up and Decay"
	Description="Try to make ninety-nine Zed balloons!"
	zedSpawnRateFactor=1.000000
	waveValueFactor=1.000000

	ZeroHealthInflation=3.000000
	InflationDeathGravity=-0.570000
	InflationExplosionTimer=1.700000
	GlobalDeflationRate=0.100000
	Damage=0.500000
	DamageBloat=1.250000

	Name="Default__WMSpecialWave_UpUpDecay"
}
