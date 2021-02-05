class WMUpgrade_Skill_FirstBlood_Counter extends Info
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
	if (Owner == None)
	{
		Destroy();
		return;
	}

	bActive = bEnable;
}

defaultproperties
{
	bActive=True

	Name="Default__WMUpgrade_Skill_FirstBlood_Counter"
}
