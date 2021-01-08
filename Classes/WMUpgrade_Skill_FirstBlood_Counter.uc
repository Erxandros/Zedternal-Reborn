class WMUpgrade_Skill_FirstBlood_Counter extends Info
	transient;

var KFPawn_Human Player;
var bool bActive;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
}

reliable server function SetFirstBlood(bool bEnable)
{
	bActive = bEnable;
}

defaultproperties
{
	bActive=True

	Name="Default__WMUpgrade_Skill_FirstBlood_Counter"
}
