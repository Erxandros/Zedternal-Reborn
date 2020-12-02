Class WMUpgrade_Skill_RankThemUp_Counter extends Info
	transient;

var KFPawn_Human Player;

var int HeadShot, MaxHeadShot;
var const float ResetDelayTimer, DecreaseDelayTimer;
var	const name RhytmMethodRTPCName;
var	const AkEvent RhythmMethodSoundReset;
var const AkEvent RhythmMethodSoundHit;
var	const AkEvent RhythmMethodSoundTop;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
}

function Timer()
{
	if (HeadShot > 0)
	{
		DecreaseCounter();
		SetTimer(DecreaseDelayTimer, False);
	}
}

function IncreaseCounter()
{
	++HeadShot;
	HeadShotMessage(HeadShot, Min(MaxHeadShot, HeadShot), Player, False, False);
	SetTimer(ResetDelayTimer, False);
}

function DecreaseCounter()
{
	HeadShot = Min(MaxHeadShot, HeadShot) - 1;
	HeadShotMessage(HeadShot, HeadShot, Player, True, False);
}

function EndStrike()
{
	//Player shot his powerful bullet, combo is cleared
	HeadShot = 0;
	HeadShotMessage(HeadShot, Min(MaxHeadShot, HeadShot), Player, False, True);
	ClearTimer();
}

reliable client function HeadShotMessage(byte HeadShotNum, byte DisplayValue, KFPawn_Human KFPlayer, optional bool bMissed=False, optional bool bFinalHit=False)
{
	local int i;
	local AkEvent TempAkEvent;
	local KFPlayerController OwnerPC;

	if (KFPlayerController(KFPlayer.Controller) == None || KFPlayerController(KFPlayer.Controller).MyGFxHUD == None)
		return;

	OwnerPC = KFPlayerController(KFPlayer.Controller);

	i = HeadShotNum;
	OwnerPC.UpdateRhythmCounterWidget(DisplayValue, MaxHeadShot);

	if (bFinalHit)
		TempAkEvent = RhythmMethodSoundTop;
	else if (!bMissed)
		TempAkEvent = RhythmMethodSoundHit;
	else if (i == 0)
		TempAkEvent = RhythmMethodSoundReset;

	if (TempAkEvent != None)
		OwnerPC.PlayRMEffect(TempAkEvent, RhytmMethodRTPCName, i);
}

defaultproperties
{
	ResetDelayTimer=5.0f
	DecreaseDelayTimer=1.5f
	HeadShot=0
	MaxHeadShot=5

	RhytmMethodRTPCName="R_Method"
	RhythmMethodSoundReset=AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Reset'
	RhythmMethodSoundHit=AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Hit'
	RhythmMethodSoundTop=AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Top'

	Name="Default__WMUpgrade_Skill_RankThemUp_Counter"
}
