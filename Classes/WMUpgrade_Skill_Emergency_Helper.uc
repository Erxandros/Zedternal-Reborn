class WMUpgrade_Skill_Emergency_Helper extends Info
	transient;

var KFPawn_Human Player;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
	else
		SetTimer(1.0f, True);
}
function Timer()
{
	if (Player == None)
		Destroy();
	else
		Player.UpdateGroundSpeed();
}

defaultproperties
{
	Name="Default__WMUpgrade_Skill_Emergency_Helper"
}
