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
	
	if (OwnerPawn != none && OwnerPawn.Health > 0)
	{
		bReady = false;
		
		Rot = rotator( OwnerPawn.Velocity );
		Rot.Pitch = 0;
		Loc = OwnerPawn.Location;
		Loc.Z -= OwnerPawn.GetCollisionHeight();
		if (bDeluxe)
			OwnerPawn.Controller.Spawn(class'ZedternalReborn.WMUpgrade_FreezeExplosion_Deluxe', OwnerPawn.Controller,, Loc, Rot,,true);
		else
			OwnerPawn.Controller.Spawn(class'ZedternalReborn.WMUpgrade_FreezeExplosion', OwnerPawn.Controller,, Loc, Rot,,true);
		PlayLocalEffects(OwnerPawn);
		SetTimer(Delay,true,nameof(UpdateColdRiposte));
	}
	else
		Destroy();
		
}

reliable client function PlayLocalEffects(KFPawn Player)
{
	local vector Loc, View;
	local rotator Rot;
	local ParticleSystemComponent PSC;
	
	if(Player != none)
	{
		Loc = Player.Location;
		Rot = Player.Rotation;
		View = vector(Player.Rotation);
		
		Loc.X += 50.f*View.X;
		Loc.Y += 50.f*View.Y;
		Loc.Z += 50.f*View.Z;
		
		PSC = Player.WorldInfo.MyEmitterPool.SpawnEmitter(default.PSBuff, Loc,  Rot);
		PSC.SetDepthPriorityGroup(SDPG_Foreground);
	}
}

function UpdateColdRiposte()
{
	bReady = true;
}


defaultproperties
{
   bOnlyRelevantToOwner = true
   bReady = true
   Delay = 40.000000
   bDeluxe = false
   PSBuff = ParticleSystem'ZedternalReborn_Resource.FX_ColdRiposte_Effect'
   Name="Default__WMUpgrade_Skill_ColdRiposte_Counter"
}
