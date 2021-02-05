class WMUpgrade_Skill_Skirmisher_Helper extends Info
	transient;

var KFPawn_Human Player;
var byte DeluxeLvl;
var const float Update;
var const array<byte> Regen;

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

	SetTimer(Update, True);
}

function Timer()
{
	if (Player == None || Player.Health <= 0)
		Destroy();
	else if (Player.Health < Player.HealthMax)
		Player.Health = Min(Player.Health + Regen[DeluxeLvl], Player.HealthMax);
}

defaultproperties
{
	DeluxeLvl=0
	Update=1.0f
	Regen(0)=1
	Regen(1)=2

	Name="Default__WMUpgrade_Skill_Skirmisher_Helper"
}
