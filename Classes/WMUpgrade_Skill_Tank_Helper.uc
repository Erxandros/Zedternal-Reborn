class WMUpgrade_Skill_Tank_Helper extends Info
	transient;

var bool bEnable;
var const float MinDelay;
var const ParticleSystem PSShield;
var const AkBaseSoundObject BlockSound;

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner == None)
		Destroy();
}

function ActiveEffect()
{
	if (!bEnable)
	{
		bEnable = True;
		PlayLocalEffects();
		SetTimer(MinDelay, False, NameOf(ResetEffect));
	}
}

function ResetEffect()
{
	if (Owner == None)
		Destroy();
	else
		bEnable = False;
}

reliable client function PlayLocalEffects()
{
	local vector Loc, View;
	local rotator Rot;
	local ParticleSystemComponent PSC;
	local PlayerController PC;

	PC = GetALocalPlayerController();

	if (PC == None || PC.Pawn == None || PC.Pawn.Health <= 0)
	{
		return;
	}

	PC.Pawn.PlaySoundBase(BlockSound, True);

	Loc = PC.Pawn.Location;
	Rot = PC.Pawn.Rotation;
	View = vector(PC.Pawn.Rotation);

	Loc.X += 50.0f * View.X;
	Loc.Y += 50.0f * View.Y;
	Loc.Z += 50.0f * View.Z;

	PSC = PC.Pawn.WorldInfo.MyEmitterPool.SpawnEmitter(PSShield, Loc, Rot);
	PSC.SetDepthPriorityGroup(SDPG_Foreground);
}

defaultproperties
{
	bOnlyRelevantToOwner=True

	bEnable=False
	MinDelay=2.0f

	PSShield=ParticleSystem'ZedternalReborn_Resource.Effects.FX_Tank_effect'
	BlockSound=AkEvent'WW_WEP_Bullet_Impacts.Play_Parry_Metal'

	Name="Default__WMUpgrade_Skill_Tank_Helper"
}
