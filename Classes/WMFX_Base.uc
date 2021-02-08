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
		if (PSEffect != None)
			PSCEffect = WorldInfo.MyEmitterPool.SpawnEmitter(PSEffect, Location, Rotation);
	}

	SetTimer(Duration, False, NameOf(RemoveFX));
}

simulated function RemoveFX()
{
	if (PSCEffect != None)
		PSCEffect.DeactivateSystem();

	Destroy();
}

defaultproperties
{
	Duration=5.0f
	RemoteRole=ROLE_SimulatedProxy
	bNetTemporary=True
	bReplicateInstigator=True
	bGameRelevant=True

	Name="Default__WMFX_Base"
}
