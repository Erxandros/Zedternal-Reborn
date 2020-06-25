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
	if(Player == none)
		Destroy();
}

reliable client function PlayLocalEffects()
{
	if(Player == none)
		Destroy();

	Player.PlaySoundBase(default.earthquakeSound, true);
	class'Camera'.static.PlayWorldCameraShake(cameraShake, Player, Player.Location, 400.f, 1500.f, 3.0f, true);
}

defaultproperties
{
	bOnlyRelevantToOwner=true
	cameraShake=KFCameraShake'ZedternalReborn_Resource.FX_CameraShake_Earthquake'
	earthquakeSound=AkEvent'ww_zed_fleshpound_2.Play_Fleshpound_Pound'
}
