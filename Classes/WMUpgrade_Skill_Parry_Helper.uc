class WMUpgrade_Skill_Parry_Helper extends Info
	transient;

var bool bOn;
var const float Delay;
var const AkEvent ParrySkillSoundModeStart;

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner == None)
		Destroy();
}

function ActiveEffect()
{
	ClearTimer(NameOf(ResetEffect));

	if (!bOn)
	{
		bOn = True;
		ActiveLocalEffects();
	}

	SetTimer(Delay, False, NameOf(ResetEffect));
}

function ResetEffect()
{
	if (Owner == None)
	{
		Destroy();
		return;
	}

	if (bOn)
	{
		ResetLocalEffects();
		bOn = False;
	}
}

reliable client function ActiveLocalEffects()
{
	local PlayerController PC;

	PC = GetALocalPlayerController();

	if (KFPlayerController(PC) != None)
	{
		KFPlayerController(PC).SetPerkEffect(True);
		PC.PlaySoundBase(ParrySkillSoundModeStart, True);
	}
}

reliable client function ResetLocalEffects()
{
	local PlayerController PC;

	PC = GetALocalPlayerController();

	if (KFPlayerController(PC) != None)
		KFPlayerController(PC).SetPerkEffect(False);
}

defaultproperties
{
	bOnlyRelevantToOwner=True
	bOn=False
	Delay=10.0f

	ParrySkillSoundModeStart=AkEvent'WW_GLO_Runtime.Play_Beserker_Parry_Mode'

	Name="Default__WMUpgrade_Skill_Parry_Helper"
}
