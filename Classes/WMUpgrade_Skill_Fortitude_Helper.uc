class WMUpgrade_Skill_Fortitude_Helper extends Info
	transient;

var KFPawn_Human Player;
var int Regen;
var bool bDeluxe;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
	else
		SetTimer(2.0f, False);
}

function Timer()
{
	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (Player.Health < Player.HealthMax)
		Player.Health = Min(Player.Health + default.Regen, Player.HealthMax);

	if (bDeluxe)
		SetTimer(1.0f, False);
	else
		SetTimer(2.0f, False);
}

defaultproperties
{
	Regen=1
	bDeluxe=False

	Name="Default__WMUpgrade_Skill_Fortitude_Helper"
}
