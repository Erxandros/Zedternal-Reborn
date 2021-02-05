class WMUpgrade_Skill_RankThemUp_Helper extends Info
	transient;

var byte HeadShot;
var const byte MaxHeadShot;
var const float DecreaseDelayTimer, ResetDelayTimer;
var const name RhytmMethodRTPCName;
var const AkEvent RhythmMethodSoundReset;
var const AkEvent RhythmMethodSoundHit;
var const AkEvent RhythmMethodSoundTop;

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner == None)
		Destroy();
}

function Timer()
{
	if (Owner == None)
	{
		Destroy();
		return;
	}

	if (HeadShot > 0)
	{
		DecreaseCounter();
		SetTimer(DecreaseDelayTimer, False);
	}
}

function IncreaseCounter()
{
	ClearTimer();
	++HeadShot;
	HeadShotMessage(HeadShot, Min(MaxHeadShot, HeadShot), False, False);
	SetTimer(ResetDelayTimer, False);
}

function DecreaseCounter()
{
	--HeadShot;
	HeadShotMessage(HeadShot, HeadShot, True, False);
}

function EndStrike()
{
	//Player shot his powerful bullet, combo is cleared
	ClearTimer();
	HeadShot = 0;
	HeadShotMessage(HeadShot, HeadShot, False, True);
}

reliable client function HeadShotMessage(byte HeadShotNum, byte DisplayValue, optional bool bMissed = False, optional bool bFinalHit = False)
{
	local byte b;
	local AkEvent TempAkEvent;
	local KFPlayerController KFPC;

	KFPC = KFPlayerController(GetALocalPlayerController());

	if (KFPC == None || KFPC.MyGFxHUD == None)
		return;

	b = HeadShotNum;
	KFPC.UpdateRhythmCounterWidget(DisplayValue, MaxHeadShot);

	if (bFinalHit)
		TempAkEvent = RhythmMethodSoundTop;
	else if (!bMissed)
		TempAkEvent = RhythmMethodSoundHit;
	else if (b == 0)
		TempAkEvent = RhythmMethodSoundReset;

	if (TempAkEvent != None)
		KFPC.PlayRMEffect(TempAkEvent, RhytmMethodRTPCName, b);
}

defaultproperties
{
	HeadShot=0
	MaxHeadShot=5
	DecreaseDelayTimer=1.5f
	ResetDelayTimer=5.0f

	RhytmMethodRTPCName="R_Method"
	RhythmMethodSoundReset=AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Reset'
	RhythmMethodSoundHit=AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Hit'
	RhythmMethodSoundTop=AkEvent'WW_UI_PlayerCharacter.Play_R_Method_Top'

	Name="Default__WMUpgrade_Skill_RankThemUp_Helper"
}
