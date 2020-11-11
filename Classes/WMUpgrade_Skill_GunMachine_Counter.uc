Class WMUpgrade_Skill_GunMachine_Counter extends Info
	transient;

var KFPawn_Human Player;
var int MaxDelay, Delay;
var bool bActive;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
	else
		SetTimer(1.0f, True);
}

function SetActive()
{
	Delay = default.MaxDelay;
	bActive = True;
}

function Timer()
{
	if (Delay > 0)
	{
		--Delay;
		if (Delay <= 0)
			bActive = False;
	}
}

defaultproperties
{
	bActive=False
	MaxDelay=5
	Delay=0

	Name="Default__WMUpgrade_Skill_GunMachine_Counter"
}
