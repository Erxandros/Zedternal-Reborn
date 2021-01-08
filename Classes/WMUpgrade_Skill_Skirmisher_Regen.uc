class WMUpgrade_Skill_Skirmisher_Regen extends Info
	transient;

var KFPawn_Human Player;
var int Regen, RegenDeluxe;
var bool bDeluxe;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
	else
		SetTimer(1.0f, True);
}

function Timer()
{
	if (Player == None || Player.Health <= 0)
		Destroy();
	else if (Player.Health < Player.HealthMax)
	{
		if (bDeluxe)
			Player.Health = Min(Player.Health + default.RegenDeluxe, Player.HealthMax);
		else
			Player.Health = Min(Player.Health + default.Regen, Player.HealthMax);
	}
}

defaultproperties
{
	Regen=1
	RegenDeluxe=2
	bDeluxe=False

	Name="Default__WMUpgrade_Skill_Skirmisher_Regen"
}
