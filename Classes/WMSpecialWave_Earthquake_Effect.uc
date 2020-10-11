Class WMSpecialWave_Earthquake_Effect extends Info
	transient;

var KFPawn_Human Player;
var AkBaseSoundObject earthquakeSound;
var KFCameraShake cameraShake;

replication
{
	if ( bNetOwner )
		Player;
}

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
}

reliable client function PlayLocalEffects()
{
	if (Player == None)
		Destroy();

	Player.PlaySoundBase(default.earthquakeSound, True);
	class'Camera'.static.PlayWorldCameraShake(cameraShake, Player, Player.Location, 400.0f, 1500.0f, 3.0f, True);
}

defaultproperties
{
	bOnlyRelevantToOwner=True
	cameraShake=KFCameraShake'ZedternalReborn_Resource.Effects.FX_CameraShake_Earthquake'
	earthquakeSound=AkEvent'ww_zed_fleshpound_2.Play_Fleshpound_Pound'
}
