class WMUpgrade_Skill_FirstBlood_Helper extends Info
	transient;

var bool bActive;

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner == None)
		Destroy();
}

function SetFirstBlood(bool bEnable)
{
	bActive = bEnable;
}

defaultproperties
{
	bActive=True

	Name="Default__WMUpgrade_Skill_FirstBlood_Helper"
}
