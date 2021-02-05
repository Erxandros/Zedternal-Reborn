class WMUpgrade_Skill_Pyromaniac_Counter extends Info
	transient;

var KFPawn_Human Player;
var bool bEnable, bDeluxe;
var const float PyromaniacLength, Delay, Radius;

replication
{
	if (Role == Role_Authority && bNetDirty)
		bEnable;
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Role == Role_Authority)
	{
		Player = KFPawn_Human(Owner);
		if (Player == None || Player.Health <= 0)
			Destroy();
		else
			SetCheckEnableTimer();
	}
}

function SetCheckEnableTimer()
{
	SetTimer(1.0f, True, NameOf(CheckEnable));
}

function CheckEnable()
{
	local int Count;
	local KFPawn_Monster KFM;

	if (Player == None || Player.Health <= 0)
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
	local PlayerController PC;

	PC = GetALocalPlayerController();

	if (KFPlayerController(PC) != None)
	{
		KFPlayerController(PC).SetPerkEffect(True);
	}
}

reliable client function ResetEffect()
{
	local PlayerController PC;

	PC = GetALocalPlayerController();

	if (KFPlayerController(PC) != None)
	{
		KFPlayerController(PC).SetPerkEffect(False);
	}
}

defaultproperties
{
	bOnlyRelevantToOwner=True
	bEnable=False
	bDeluxe=False
	PyromaniacLength=4.0f
	Delay=6.0f
	Radius=150000

	Name="Default__WMUpgrade_Skill_Pyromaniac_Counter"
}
