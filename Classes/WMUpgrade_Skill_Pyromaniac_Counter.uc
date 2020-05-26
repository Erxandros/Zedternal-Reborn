Class WMUpgrade_Skill_Pyromaniac_Counter extends Info
	transient;

var KFPawn_Human Player;

var bool bEnable;
var float pyromaniacLength, Delay;
var float Radius;
var bool bDeluxe;

replication
{
	if ( bNetOwner )
		Player;
}

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none)
		Destroy();

	SetCheckEnableTimer();
}

function SetCheckEnableTimer()
{
	SetTimer(1.0f, true, nameof(CheckEnable));
}

function CheckEnable()
{
	local int Count;
	local KFPawn_Monster KFM;

	if (Player == none)
		Destroy();
	else
	{
		Count = 0;
		foreach DynamicActors(class'KFPawn_Monster', KFM)
		{
			if (KFM.IsAliveAndWell() && VSizeSQ(Player.Location - KFM.Location) <= Radius)
				++Count;
		}

		if ((bDeluxe && Count >= 3) || (!bDeluxe && Count >= 4))
		{
			if (!bEnable)
			{
				ClearTimer(nameof(CheckEnable));
				ActiveEffect();
				bEnable = true;
				SetTimer(pyromaniacLength, true, nameof(CheckEnable));
			}
		}
		else if (bEnable)
		{
			ClearTimer(nameof(CheckEnable));
			ResetEffect();
			bEnable = false;
			SetTimer(Delay, false, nameof(SetCheckEnableTimer));
		}
	}
}

function EndWaveReset()
{
	ClearAllTimers();
	ResetEffect();
	bEnable = false;
	SetTimer(Delay, false, nameof(SetCheckEnableTimer));
}

// client effects
reliable client function ActiveEffect()
{
	if (KFPlayerController(Player.Controller) != none)
		KFPlayerController(Player.Controller).SetPerkEffect(true);
}

reliable client function ResetEffect()
{
	if (KFPlayerController(Player.Controller) != none)
		KFPlayerController(Player.Controller).SetPerkEffect(false);
}

defaultproperties
{
	bOnlyRelevantToOwner=true
	bEnable=false
	pyromaniacLength=4.0f
	Delay=8.0f
	Radius=150000
	bDeluxe=false
	Name="Default__WMUpgrade_Skill_Pyromaniac_Counter"
}
