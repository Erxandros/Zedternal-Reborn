Class WMUpgrade_Skill_FirstBlood_Counter extends Info
	transient;

var KFPawn_Human Player;
var bool bActive;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none)
		Destroy();
}

reliable server function SetFirstBlood(bool bEnable)
{
	bActive = bEnable;
}

defaultproperties
{
   bActive=true
   Name="Default__WMUpgrade_Skill_FirstBlood_Counter"
}
