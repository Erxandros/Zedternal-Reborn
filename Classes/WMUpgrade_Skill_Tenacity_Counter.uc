Class WMUpgrade_Skill_Tenacity_Counter extends Info
	transient;

var KFPawn_Human Player;
var int MaxDelay, Delay;
var bool bActive;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none)
		Destroy();
	
	SetTimer(1.f, true);
}

function SetActive()
{
	Delay = MaxDelay;
	bActive = true;
}

function Timer()
{
	if (Delay > 0)
	{
		Delay -= 1;
		if (Delay == 0)
			bActive = false;
	}
}

defaultproperties
{
   bActive=false
   MaxDelay=5
   Delay=0
   Name="Default__WMUpgrade_Skill_Tenacity_Counter"
}
