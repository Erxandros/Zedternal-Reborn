class WMSpecialWave_UpUpDecay extends WMSpecialWave;

var float Damage, DamageBloat, GlobalDeflationRate, InflationDeathGravity, InflationExplosionTimer, ZeroHealthInflation;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(2.0f, True, NameOf(UpdateZed));
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (KFPawn_ZedBloat(MyKFPM) != None)
		InDamage += Round(float(DefaultDamage) * default.DamageBloat);
	else
		InDamage += Round(float(DefaultDamage) * default.Damage);
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (!KFM.bUseDamageInflation)
		{
			KFM.bUseDamageInflation = True;
			KFM.ZeroHealthInflation = default.ZeroHealthInflation;
			KFM.DamageDeflationRate = default.GlobalDeflationRate;
			KFM.bDisableGoreMeshWhileAlive = True;
			KFM.InflationExplosionTimer = default.InflationExplosionTimer;
			KFM.InflateDeathGravity = default.InflationDeathGravity;
		}
	}
}

defaultproperties
{
	Damage=0.5f
	DamageBloat=1.25f
	GlobalDeflationRate=0.1f
	InflationDeathGravity=-0.57f
	InflationExplosionTimer=1.7f
	ZeroHealthInflation=3.0f

	Title="Up, Up and Decay"
	Description="Try to make ninety-nine Zed balloons!"

	Name="Default__WMSpecialWave_UpUpDecay"
}
