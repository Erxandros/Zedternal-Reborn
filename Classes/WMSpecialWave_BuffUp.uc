class WMSpecialWave_BuffUp extends WMSpecialWave;

var float DamageSizeScale, ScaleDelta, ScaleMax;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(6.0f, True, NameOf(UpdateZed));
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFM.IntendedBodyScale < default.ScaleMax && KFM.IntendedBodyScale != class'ZedternalReborn.WMSpecialWave_Division'.default.SmallZedSize)
			KFM.IntendedBodyScale += default.ScaleDelta;
	}
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local float ScalePercent;

	if (MyKFPM != None)
	{
		ScalePercent = MyKFPM.IntendedBodyScale * default.DamageSizeScale;
		InDamage += Round(float(InDamage) * ScalePercent);
	}
}

defaultproperties
{
	DamageSizeScale=1.0f
	ScaleDelta=0.04f
	ScaleMax=1.6f

	Title="Buff Up"
	Description="They grow fast!"

	Name="Default__WMSpecialWave_BuffUp"
}
