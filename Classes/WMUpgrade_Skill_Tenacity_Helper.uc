class WMUpgrade_Skill_Tenacity_Helper extends Info
	transient;

var bool bActive;
var const float MaxDelay;

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner == None)
		Destroy();
}

function SetActive()
{
	ClearTimer(NameOf(Reset));
	bActive = True;
	SetTimer(MaxDelay, False, NameOf(Reset));
}

function Reset()
{
	if (Owner == None)
		Destroy();
	else
		bActive = False;
}

defaultproperties
{
	bActive=False
	MaxDelay=5.0f

	Name="Default__WMUpgrade_Skill_Tenacity_Helper"
}
