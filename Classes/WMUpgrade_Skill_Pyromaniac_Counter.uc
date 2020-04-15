Class WMUpgrade_Skill_Pyromaniac_Counter extends Info
	transient;

var KFPawn_Human Player;
var bool bOn;
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
	SetTimer(1.f, true);
}

function Timer()
{
	local int Count;
	local KFPawn_Monster KFM;
	
	if (!bOn && Player != none)
	{
		Count = 0;
		foreach DynamicActors(class'KFPawn_Monster', KFM)
		{
			if ( KFM.IsAliveAndWell() && VSizeSQ( Player.Location - KFM.Location ) <= Radius )
				Count++;
		}
		if ((bDeluxe && Count >= 3) || (!bDeluxe && Count >= 4) )
		{
			bOn = true;
			TriggerPyromaniac();
		}
	}
	else if (Player == none)
	{
		Destroy();
	}
}

function TriggerPyromaniac()
{
	bOn = true;
	ActiveEffect(); // client side effect

	ClearTimer(NameOf(ResetPyromaniac));
	SetTimer(pyromaniacLength + Delay,false, NameOf(ResetPyromaniac));
}

function ResetPyromaniac()
{
	bOn = false;
}

// client effects
reliable client function ActiveEffect()
{
	bOn = true;
	
	if (KFPlayerController(Player.Controller) != none)
		KFPlayerController(Player.Controller).SetPerkEffect(true);
	
	ClearTimer(NameOf(ResetEffect));
	SetTimer(pyromaniacLength, false, NameOf(ResetEffect));
}
simulated function ResetEffect()
{
	bOn = false;
	
	if (KFPlayerController(Player.Controller) != none)
		KFPlayerController(Player.Controller).SetPerkEffect(false);
}
reliable client function ForceTurnOffEffect()
{
	bOn = false;
	
	if (KFPlayerController(Player.Controller) != none)
		KFPlayerController(Player.Controller).SetPerkEffect(false);
}


defaultproperties
{
   bOnlyRelevantToOwner=true
   bOn=false
   pyromaniacLength=3.000000
   Delay=10.000000
   Radius=150000
   bDeluxe=false
   Name="Default__WMUpgrade_Skill_Pyromaniac_Counter"
}
