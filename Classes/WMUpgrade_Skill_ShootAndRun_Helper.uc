class WMUpgrade_Skill_ShootAndRun_Helper extends Info
	transient;

var KFPawn_Human Player;
var byte KilledZeds;
var const byte MaxKilledZeds;
var const float ResetTimerDelay, DecreaseTimerDelay;

replication
{
	if (Role == Role_Authority && bNetDirty)
		KilledZeds;
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
			KilledZeds = 0;
	}
}

function Timer()
{
	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (KilledZeds > 0)
	{
		--KilledZeds;
		Player.UpdateGroundSpeed();
		if (KilledZeds != 0)
			SetTimer(DecreaseTimerDelay, False);
	}
}

function IncreaseCounter()
{
	ClearTimer();
	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (KilledZeds < MaxKilledZeds)
		++KilledZeds;

	Player.UpdateGroundSpeed();
	SetTimer(ResetTimerDelay, False);
}

simulated function float GetKillPercentage()
{
	return float(KilledZeds) / float(MaxKilledZeds);
}

defaultproperties
{
	ResetTimerDelay=3.75f
	DecreaseTimerDelay=0.75f
	MaxKilledZeds=10

	Name="Default__WMUpgrade_Skill_ShootAndRun_Helper"
}
