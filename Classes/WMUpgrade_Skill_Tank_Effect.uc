class WMUpgrade_Skill_Tank_Effect extends Info
	transient;

var bool bDeluxe, bOn;
var KFPawn_Human Player;
var int OldHealth;
var float MinDelay;

var array<float> Critical;

var ParticleSystem PSShield;
var AkBaseSoundObject BlockSound;

replication
{
	if ( bNetOwner )
		Player;
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
}

simulated function Tick(float Delta)
{
	local WorldInfo WI;
	local float Limit;

	if (Player == None)
	{
		Destroy();
		return;
	}

	WI = class'WorldInfo'.static.GetWorldInfo();

	if (WI.NetMode == NM_Client)
	{
		if (OldHealth == 0)
			OldHealth = Player.Health;

		if (bDeluxe)
			Limit = default.Critical[1];
		else
			Limit = default.Critical[0];

		if (!bOn && OldHealth > Player.Health && Player.Health >= int(float(Player.HealthMax) * Limit))
		{
			OldHealth = Player.Health;
			bOn = True;
			PlayLocalEffects();
			SetTimer(default.MinDelay, False, nameof(ResetEffect));
		}
		else if (!bOn && OldHealth > Player.Health)
			OldHealth = Player.Health;
	}
}

simulated function ResetEffect()
{
	bOn = False;
}

simulated function PlayLocalEffects()
{
	local vector Loc, View;
	local rotator Rot;
	local ParticleSystemComponent PSC;

	if (Player == None)
	{
		Destroy();
		return;
	}

	Player.PlaySoundBase(default.BlockSound, True);

	Loc = Player.Location;
	Rot = Player.Rotation;
	View = vector(Player.Rotation);

	Loc.X += 50.0f * View.X;
	Loc.Y += 50.0f * View.Y;
	Loc.Z += 50.0f * View.Z;

	PSC = Player.WorldInfo.MyEmitterPool.SpawnEmitter(default.PSShield, Loc, Rot);
	PSC.SetDepthPriorityGroup(SDPG_Foreground);
}

defaultproperties
{
	bOnlyRelevantToOwner=True

	bDeluxe=False
	bOn=False
	OldHealth=0
	MinDelay=1.0f
	Critical(0)=0.9f
	Critical(1)=0.7f

	PSShield=ParticleSystem'ZedternalReborn_Resource.Effects.FX_Tank_effect'
	BlockSound=AkEvent'WW_WEP_Bullet_Impacts.Play_Parry_Metal'

	Name="Default__WMUpgrade_Skill_Tank_Effect"
}
