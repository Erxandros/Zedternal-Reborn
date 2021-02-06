class WMUpgrade_Skill_Pyromaniac_Helper extends Info
	transient;

var KFPawn_Human Player;
var bool bEnable;
var byte DeluxeLvl;
var const float PyromaniacLength, Radius, ResetDelay, Update;
var array<byte> ZedThreshold;

replication
{
	if (Role == Role_Authority && bNetDirty)
		bEnable;
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
}

function StartTimer(bool bDeluxe)
{
	if (bDeluxe)
		DeluxeLvl = 1;
	else
		DeluxeLvl = 0;

	SetTimer(Update, False);
}

function Timer()
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

	if (Count >= ZedThreshold[DeluxeLvl])
	{
		if (!bEnable)
		{
			ActiveEffect();
			bEnable = True;
			SetTimer(PyromaniacLength, False);
			return;
		}
	}
	else if (bEnable)
	{
		ResetEffect();
		bEnable = False;
		SetTimer(ResetDelay, False);
		return;
	}

	SetTimer(Update, False);
}

function EndWaveReset()
{
	ClearTimer();
	ResetEffect();
	bEnable = False;
	SetTimer(Update, False);
}

// client effects
reliable client function ActiveEffect()
{
	local KFPlayerController KFPC;

	KFPC = KFPlayerController(GetALocalPlayerController());

	if (KFPC != None)
		KFPC.SetPerkEffect(True);
}

reliable client function ResetEffect()
{
	local KFPlayerController KFPC;

	KFPC = KFPlayerController(GetALocalPlayerController());

	if (KFPC != None)
		KFPC.SetPerkEffect(False);
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bSkipActorPropertyReplication=False
	bOnlyRelevantToOwner=True
	bEnable=False
	DeluxeLvl=0
	PyromaniacLength=4.0f
	Radius=150000
	ResetDelay=6.0f
	Update=1.0f
	ZedThreshold(0)=4
	ZedThreshold(1)=3

	Name="Default__WMUpgrade_Skill_Pyromaniac_Helper"
}
