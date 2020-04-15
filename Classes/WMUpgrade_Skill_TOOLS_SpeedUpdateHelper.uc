Class WMUpgrade_Skill_TOOLS_SpeedUpdateHelper extends Info
	transient;

var KFPawn_Human Player;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none)
		Destroy();
	else
		SetTimer(1.f, true);
}
function Timer()
{
	if(Player==None)
		Destroy();
	else
		Player.UpdateGroundSpeed();
}

defaultproperties
{
   Name="Default__WMUpgrade_Skill_TOOLS_SpeedUpdateHelper"
}
