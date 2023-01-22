class WMUpgrade_Skill_FirstBlood_Helper extends Info
	transient;

var bool bActive;
var float Time;

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner == None)
		Destroy();
}

function StartFirstBloodTimer()
{
	if (!IsTimerActive(NameOf(DisableFirstBloodFlag)))
		SetTimer(Time, False, NameOf(DisableFirstBloodFlag));
}

function DisableFirstBloodFlag()
{
	bActive = False;
}

function EnableFirstBloodFlag()
{
	bActive = True;
}

defaultproperties
{
	bActive=True
	Time=0.5f

	Name="Default__WMUpgrade_Skill_FirstBlood_Helper"
}
