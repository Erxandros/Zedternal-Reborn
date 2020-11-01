Class WMUpgrade_Skill_ColdRiposte_Counter extends Info
	transient;

var float Delay;
var bool bReady;
var bool bDeluxe;
var ParticleSystem PSBuff;

function Explosion(KFPawn OwnerPawn)
{
	local rotator Rot;
	local vector Loc;

	if (OwnerPawn != None && OwnerPawn.Health > 0)
	{
		bReady = False;

		Rot = rotator(OwnerPawn.Velocity);
		Rot.Pitch = 0;
		Loc = OwnerPawn.Location;
		Loc.Z -= OwnerPawn.GetCollisionHeight();
		if (bDeluxe)
			OwnerPawn.Controller.Spawn(class'ZedternalReborn.WMProj_FreezeExplosion_Deluxe', OwnerPawn.Controller, , Loc, Rot, , True);
		else
			OwnerPawn.Controller.Spawn(class'ZedternalReborn.WMProj_FreezeExplosion', OwnerPawn.Controller, , Loc, Rot, , True);
		PlayLocalEffects(OwnerPawn);
		SetTimer(Delay, False, nameof(UpdateColdRiposte));
	}
	else
		Destroy();
}

reliable client function PlayLocalEffects(KFPawn Player)
{
	local vector Loc, View;
	local rotator Rot;
	local ParticleSystemComponent PSC;

	if (Player != None)
	{
		Loc = Player.Location;
		Rot = Player.Rotation;
		View = vector(Player.Rotation);

		Loc.X += 50.0f * View.X;
		Loc.Y += 50.0f * View.Y;
		Loc.Z += 50.0f * View.Z;

		PSC = Player.WorldInfo.MyEmitterPool.SpawnEmitter(default.PSBuff, Loc, Rot);
		PSC.SetDepthPriorityGroup(SDPG_Foreground);
	}
}

function UpdateColdRiposte()
{
	bReady = True;
}

defaultproperties
{
	bOnlyRelevantToOwner=True
	bReady=True
	Delay=40.0f
	bDeluxe=False
	PSBuff=ParticleSystem'ZedternalReborn_Resource.Effects.FX_ColdRiposte_Effect'

	Name="Default__WMUpgrade_Skill_ColdRiposte_Counter"
}
