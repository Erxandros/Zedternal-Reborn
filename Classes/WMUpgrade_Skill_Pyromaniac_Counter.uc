Class WMUpgrade_Skill_Pyromaniac_Counter extends Info
	transient;

var KFPawn_Human Player;
var bool bEnable, bDeluxe;
var float PyromaniacLength, Delay, Radius;

replication
{
	if ( bNetOwner )
		Player;
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
	else
		SetCheckEnableTimer();
}

function SetCheckEnableTimer()
{
	SetTimer(1.0f, True, NameOf(CheckEnable));
}

function CheckEnable()
{
	local int Count;
	local KFPawn_Monster KFM;

	if (Player == None)
	{
		Destroy();
		return;
	}

	Count = 0;
	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFM.IsAliveAndWell() && VSizeSQ(Player.Location - KFM.Location) <= Radius)
			++Count;
	}

	if ((bDeluxe && Count >= 3) || Count >= 4)
	{
		if (!bEnable)
		{
			ClearTimer(NameOf(CheckEnable));
			ActiveEffect();
			bEnable = True;
			SetTimer(PyromaniacLength, True, NameOf(CheckEnable));
		}
	}
	else if (bEnable)
	{
		ClearTimer(NameOf(CheckEnable));
		ResetEffect();
		bEnable = False;
		SetTimer(Delay, False, NameOf(SetCheckEnableTimer));
	}
}

function EndWaveReset()
{
	ClearAllTimers();
	ResetEffect();
	bEnable = False;
	SetTimer(Delay, False, NameOf(SetCheckEnableTimer));
}

// client effects
reliable client function ActiveEffect()
{
	if (KFPlayerController(Player.Controller) != None)
		KFPlayerController(Player.Controller).SetPerkEffect(True);
}

reliable client function ResetEffect()
{
	if (KFPlayerController(Player.Controller) != None)
		KFPlayerController(Player.Controller).SetPerkEffect(False);
}

defaultproperties
{
	bOnlyRelevantToOwner=True
	bEnable=False
	bDeluxe=False
	PyromaniacLength=4.0f
	Delay=8.0f
	Radius=150000

	Name="Default__WMUpgrade_Skill_Pyromaniac_Counter"
}
