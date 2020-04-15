Class WMUpgrade_Skill_RankThemUp_Counter extends Info
	transient;

var KFPawn_Human Player;

var int headShot, maxHeadShot;

var const float resetDelayTimer, decreaseDelayTimer;
var	const name RhytmMethodRTPCName;
var	const AkEvent RhythmMethodSoundReset;
var const AkEvent RhythmMethodSoundHit;
var	const AkEvent RhythmMethodSoundTop;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none)
		Destroy();
	
	headShot = 0;
}

function Timer()
{
	if (headShot > 0)
	{
		DecreaseCounter();
		SetTimer(decreaseDelayTimer, false);
	}
}

function IncreaseCounter()
{
	headShot += 1;
	HeadShotMessage(headShot, min(maxHeadShot,headShot), Player, false, false);
	SetTimer(resetDelayTimer, false);
}

function DecreaseCounter()
{
	headShot = min(maxHeadShot, headShot) - 1;
	HeadShotMessage(headShot, headShot, Player, true, false);
}

function EndStrike()
{
	//Player shot his powerful bullet, combo is cleared
	headShot = 0;
	HeadShotMessage(headShot, min(maxHeadShot,headShot), Player, false, true);
	ClearTimer();
}

reliable client function HeadShotMessage( byte HeadShotNum, byte DisplayValue, KFPawn_Human KFPlayer, optional bool bMissed=false, optional bool bFinalHit=false )
{
	local int i;
	local AkEvent TempAkEvent;
	local KFPlayerController OwnerPC;
	
	if( KFPlayerController(KFPlayer.Controller) == none || KFPlayerController(KFPlayer.Controller).MyGFxHUD == none)
	{
		return;
	}
	
	OwnerPC = KFPlayerController(KFPlayer.Controller);

	i = HeadshotNum;
	OwnerPC.UpdateRhythmCounterWidget( DisplayValue, maxHeadShot );

	if (bFinalHit)
		TempAkEvent = RhythmMethodSoundTop;
	else if (!bMissed)
	{
		if (i < maxHeadShot)
			TempAkEvent = RhythmMethodSoundHit;
		else
			TempAkEvent = RhythmMethodSoundHit;
	}
	else if (i == 0)
		TempAkEvent = RhythmMethodSoundReset;

	if( TempAkEvent != none )
		OwnerPC.PlayRMEffect( TempAkEvent, RhytmMethodRTPCName, i );
}

defaultproperties
{
   resetDelayTimer=5.000000
   decreaseDelayTimer=1.500000
   headShot=0
   maxHeadShot=5
   RhytmMethodRTPCName="R_Method"
   RhythmMethodSoundReset=AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Reset'
   RhythmMethodSoundHit=AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Hit'
   RhythmMethodSoundTop=AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Top'
   Name="Default__WMUpgrade_Skill_RankThemUp_Counter"
}
