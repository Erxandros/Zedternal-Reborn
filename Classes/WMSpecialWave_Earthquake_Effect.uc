class WMSpecialWave_Earthquake_Effect extends Info
	transient;

var const AkBaseSoundObject EarthquakeSound;
var const KFCameraShake CameraShake;

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner == None)
		Destroy();
}

reliable client function PlayLocalEffects()
{
	local PlayerController PC;

	PC = GetALocalPlayerController();

	if (PC != None && PC.Pawn != None)
	{
		PC.Pawn.PlaySoundBase(EarthquakeSound, True);
		class'Camera'.static.PlayWorldCameraShake(CameraShake, PC.Pawn, PC.Pawn.Location, 400.0f, 1500.0f, 3.0f, True);
	}
}

defaultproperties
{
	bOnlyRelevantToOwner=True
	EarthquakeSound=AkEvent'ww_zed_fleshpound_2.Play_Fleshpound_Pound'
	CameraShake=KFCameraShake'ZedternalReborn_Resource.Effects.FX_CameraShake_Earthquake'

	Name="Default__WMSpecialWave_Earthquake_Effect"
}
