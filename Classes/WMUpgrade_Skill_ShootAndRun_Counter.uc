Class WMUpgrade_Skill_ShootAndRun_Counter extends Info
	transient;

var KFPawn_Human Player;
var int killedZed, maxKilledZed;
var const float resetTimerDelay, decreaseTimerDelay;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none || Player.Health <= 0)
		Destroy();

	killedZed = 0;
}
function Timer()
{
	if(Player==none || Player.Health <= 0)
		Destroy();
	
	if (killedZed > 0)
	{
		killedZed -= 1;
		SendKilledZed(killedZed, Player);
		if (killedZed!=0)
			SetTimer(decreaseTimerDelay, false);
	}
}

function IncreaseCounter()
{
	if(Player==none || Player.Health <= 0)
		Destroy();
	
	if (killedZed < default.maxKilledZed)
		killedZed += 1;
	SendKilledZed(killedZed, Player);
	SetTimer(resetTimerDelay, false);
}

reliable client function SendKilledZed(int kills, KFPawn_Human KFPlayer)
{
	killedZed = kills;
	KFPlayer.UpdateGroundSpeed();
}

defaultproperties
{
   resetTimerDelay=3.750000
   decreaseTimerDelay=0.750000
   maxKilledZed=10
   Name="Default__WMUpgrade_Skill_ShootAndRun_Counter"
}
