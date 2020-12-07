Class WMUpgrade_Skill_ShootAndRun_Counter extends Info
	transient;

var KFPawn_Human Player;
var int killedZed, maxKilledZed;
var const float resetTimerDelay, decreaseTimerDelay;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
	else
		killedZed = 0;
}

function Timer()
{
	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (killedZed > 0)
	{
		--killedZed;
		SendKilledZed(killedZed, Player);
		if (killedZed != 0)
			SetTimer(decreaseTimerDelay, False);
	}
}

function IncreaseCounter()
{
	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (killedZed < default.maxKilledZed)
		++killedZed;

	SendKilledZed(killedZed, Player);
	SetTimer(resetTimerDelay, False);
}

reliable client function SendKilledZed(int kills, KFPawn_Human KFPlayer)
{
	killedZed = kills;
	KFPlayer.UpdateGroundSpeed();
}

defaultproperties
{
	resetTimerDelay=3.75f
	decreaseTimerDelay=0.75f
	maxKilledZed=10

	Name="Default__WMUpgrade_Skill_ShootAndRun_Counter"
}
