class WMUpgrade_Skill_RankThemUp_Counter extends Info
	transient;

var int HeadShot, MaxHeadShot;
var const float ResetDelayTimer, DecreaseDelayTimer;
var const name RhytmMethodRTPCName;
var const AkEvent RhythmMethodSoundReset;
var const AkEvent RhythmMethodSoundHit;
var const AkEvent RhythmMethodSoundTop;

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
	ClearTimer();
	++HeadShot;
	HeadShotMessage(HeadShot, Min(MaxHeadShot, HeadShot), False, False);
	SetTimer(ResetDelayTimer, False);
}

function DecreaseCounter()
{
	HeadShot = Min(MaxHeadShot, HeadShot) - 1;
	HeadShotMessage(HeadShot, HeadShot, True, False);
}

function EndStrike()
{
	//Player shot his powerful bullet, combo is cleared
	ClearTimer();
	HeadShot = 0;
	HeadShotMessage(HeadShot, Min(MaxHeadShot, HeadShot), False, True);
}

reliable client function HeadShotMessage(byte HeadShotNum, byte DisplayValue, optional bool bMissed = False, optional bool bFinalHit = False)
{
	local byte b;
	local AkEvent TempAkEvent;
	local KFPlayerController OwnerPC;

	OwnerPC = KFPlayerController(GetALocalPlayerController());

	if (OwnerPC == None || OwnerPC.MyGFxHUD == None)
		return;

	b = HeadShotNum;
	OwnerPC.UpdateRhythmCounterWidget(DisplayValue, MaxHeadShot);

	if (bFinalHit)
		TempAkEvent = RhythmMethodSoundTop;
	else if (!bMissed)
		TempAkEvent = RhythmMethodSoundHit;
	else if (b == 0)
		TempAkEvent = RhythmMethodSoundReset;

	if (TempAkEvent != None)
		OwnerPC.PlayRMEffect(TempAkEvent, RhytmMethodRTPCName, b);
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
