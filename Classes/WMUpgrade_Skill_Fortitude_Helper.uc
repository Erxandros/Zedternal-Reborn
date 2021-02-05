class WMUpgrade_Skill_Fortitude_Helper extends Info
	transient;

var KFPawn_Human Player;
var const byte Regen;
var const array<float> TimeRegen;

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
		SetTimer(TimeRegen[1], True);
	else
		SetTimer(TimeRegen[0], True);
}

function Timer()
{
	if (Player == None || Player.Health <= 0)
		Destroy();
	else if (Player.Health < Player.HealthMax)
		Player.Health = Min(Player.Health + Regen, Player.HealthMax);
}

defaultproperties
{
	Regen=1
	TimeRegen(0)=2.0f
	TimeRegen(1)=1.0f

	Name="Default__WMUpgrade_Skill_Fortitude_Helper"
}
