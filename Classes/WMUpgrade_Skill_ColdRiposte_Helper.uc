class WMUpgrade_Skill_ColdRiposte_Helper extends Info
	transient;

var KFPawn_Human Player;
var bool bDeluxe, bReady;
var const float Delay;
var const ParticleSystem PSBuff;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
}

function Explosion()
{
	local rotator Rot;
	local vector Loc;

	bReady = False;

	Rot = rotator(Player.Velocity);
	Rot.Pitch = 0;
	Loc = Player.Location;
	Loc.Z -= Player.GetCollisionHeight();
	if (bDeluxe)
		Player.Controller.Spawn(class'ZedternalReborn.WMProj_FreezeExplosion_Deluxe', Player.Controller, , Loc, Rot, , True);
	else
		Player.Controller.Spawn(class'ZedternalReborn.WMProj_FreezeExplosion', Player.Controller, , Loc, Rot, , True);
	PlayLocalEffects();
	SetTimer(Delay, False, nameof(UpdateColdRiposte));
}

reliable client function PlayLocalEffects()
{
	local vector Loc, View;
	local rotator Rot;
	local ParticleSystemComponent PSC;
	local PlayerController PC;

	PC = GetALocalPlayerController();

	if (PC != None && PC.Pawn != None)
	{
		Loc = PC.Pawn.Location;
		Rot = PC.Pawn.Rotation;
		View = vector(PC.Pawn.Rotation);

		Loc.X += 50.0f * View.X;
		Loc.Y += 50.0f * View.Y;
		Loc.Z += 50.0f * View.Z;

		PSC = PC.Pawn.WorldInfo.MyEmitterPool.SpawnEmitter(default.PSBuff, Loc, Rot);
		PSC.SetDepthPriorityGroup(SDPG_Foreground);
	}
}

function UpdateColdRiposte()
{
	if (Player == None || Player.Health <= 0)
		Destroy();
	else
		bReady = True;
}

defaultproperties
{
	bOnlyRelevantToOwner=True
	bDeluxe=False
	bReady=True
	Delay=40.0f

	PSBuff=ParticleSystem'ZedternalReborn_Resource.Effects.FX_ColdRiposte_Effect'

	Name="Default__WMUpgrade_Skill_ColdRiposte_Helper"
}
