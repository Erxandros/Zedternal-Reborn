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
	Player = KFPawn_Human(Owner);
	if(Player==none || Player.Health <= 0)
		Destroy();
}

simulated function ActiveEffect()
{
	if(Player==none || Player.Health <= 0)
		Destroy();
	
	if (!bOn)
	{
		Player.UpdateGroundSpeed();
		bOn = true;
		if (KFPlayerController(Player.Controller) != none)
			KFPlayerController(Player.Controller).SetPerkEffect(true);
	}
	SetTimer(Delay,false, NameOf(ResetEffect));
}

simulated function ResetEffect()
{
	if(Player==none || Player.Health <= 0)
		Destroy();
	if (bOn)
	{
		bOn = false;
		Player.UpdateGroundSpeed();
		if (KFPlayerController(Player.Controller) != none)
			KFPlayerController(Player.Controller).SetPerkEffect(false);
	}
}

simulated function PlayLocalEffects(AKBaseSoundObject Sound)
{
	if(Player==none || Player.Health <= 0)
		Destroy();
	if ( Sound != None )
		Player.PlaySoundBase( ParrySkillSoundModeStart, true );
}

defaultproperties
{
   bOnlyRelevantToOwner = true
   bOn = false
   Delay = 8.000000
   Name="Default__WMUpgrade_Skill_Parry_Counter"
}
