class WMUpgrade_Skill_GunMachine_Helper extends Info
	transient;

var bool bActive;
var const float ResetDelay;

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
	SetTimer(ResetDelay, False, NameOf(Reset));
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
	ResetDelay=5.0f

	Name="Default__WMUpgrade_Skill_GunMachine_Helper"
}
