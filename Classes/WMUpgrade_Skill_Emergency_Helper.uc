class WMUpgrade_Skill_Emergency_Helper extends Info
	transient;

var KFPawn_Human Player;
var const float Update;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
	else
		SetTimer(Update, True);
}

function Timer()
{
	if (Player == None || Player.Health <= 0)
		Destroy();
	else
		Player.UpdateGroundSpeed();
}

defaultproperties
{
	Update=1.0f

	Name="Default__WMUpgrade_Skill_Emergency_Helper"
}
