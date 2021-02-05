class WMUpgrade_Skill_Parry_Helper extends Info
	transient;

var KFPawn_Human Player;
var bool bOn;
var float Delay;

var AkEvent ParrySkillSoundModeStart;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
}

function ActiveEffect()
{
	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (!bOn)
	{
		bOn = True;
		ActiveLocalEffects();
	}

	ClearTimer(NameOf(ResetEffect));
	SetTimer(Delay, False, NameOf(ResetEffect));
}

function ResetEffect()
{
	if (Player == None || Player.Health <= 0)
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
	{
		KFPlayerController(PC).SetPerkEffect(False);
	}
}

defaultproperties
{
	bOnlyRelevantToOwner=True
	bOn=False
	Delay=10.0f

	ParrySkillSoundModeStart=AkEvent'WW_GLO_Runtime.Play_Beserker_Parry_Mode'

	Name="Default__WMUpgrade_Skill_Parry_Helper"
}
