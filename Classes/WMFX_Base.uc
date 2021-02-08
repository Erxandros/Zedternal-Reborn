class WMFX_Base extends Actor
	abstract;

// FX spawned by the server and shown to all clients

var ParticleSystem PSEffect;
var ParticleSystemComponent PSCEffect;
var float Duration;

simulated function PostBeginPlay()
{
	// only show effect to clients
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (PSEffect != none)
		{
			PSCEffect = WorldInfo.MyEmitterPool.SpawnEmitter(PSEffect, Location, Rotation);
			//if (PSCEffect != none)
			//	PSCEffect.SetDepthPriorityGroup(SDPG_Foreground);
		}
	}

	SetTimer(Duration, false, nameof(RemoveFX));
}

simulated function RemoveFX()
{
	if (PSCEffect != none)
		PSCEffect.DeactivateSystem();

	Destroy();
}

defaultproperties
{
	Duration=5.000000
	RemoteRole=ROLE_SimulatedProxy
    bNetTemporary=True
    bReplicateInstigator=True
    bGameRelevant=True
}