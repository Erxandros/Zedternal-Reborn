Class WMUpgrade_Skill_Parry_Counter extends Info
	transient;

var KFPawn_Human Player;
var bool bOn;
var float Delay;

var AkEvent ParrySkillSoundModeStart;
var AkEvent ParrySkillSoundModeStop;

replication
{
	if ( bNetOwner )
		Player;
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
}

simulated function ActiveEffect()
{
	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}
	
	if (!bOn)
	{
		Player.UpdateGroundSpeed();
		bOn = True;
		if (KFPlayerController(Player.Controller) != None)
			KFPlayerController(Player.Controller).SetPerkEffect(True);
	}
	SetTimer(Delay, False, NameOf(ResetEffect));
}

simulated function ResetEffect()
{
	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (bOn)
	{
		bOn = False;
		Player.UpdateGroundSpeed();
		if (KFPlayerController(Player.Controller) != None)
			KFPlayerController(Player.Controller).SetPerkEffect(False);
	}
}

simulated function PlayLocalEffects(AKBaseSoundObject Sound)
{
	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (Sound != None)
		Player.PlaySoundBase(ParrySkillSoundModeStart, True);
}

defaultproperties
{
	bOnlyRelevantToOwner=True
	bOn=False
	Delay=8.0f

	ParrySkillSoundModeStart=AkEvent'WW_GLO_Runtime.Play_Beserker_Parry_Mode'
	ParrySkillSoundModeStop=AkEvent'WW_GLO_Runtime.Stop_Beserker_Parry_Mode'

	Name="Default__WMUpgrade_Skill_Parry_Counter"
}
