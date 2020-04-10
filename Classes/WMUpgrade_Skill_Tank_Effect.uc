Class WMUpgrade_Skill_Tank_Effect extends Info
	transient;

var KFPawn_Human Player;
var int oldHealth;
var float minDelay;
var bool bOn;
var bool bDeluxe;
var array<float> critical;

var ParticleSystem PSShield;

var AkBaseSoundObject BlockSound;

replication
{
	if ( bNetOwner )
		Player;
}

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none)
		Destroy();
}

simulated function Tick( float Delta )
{
	local WorldInfo WI;
	local float limit;

	if (Player == none)
		Destroy();
	
	WI = class'WorldInfo'.static.GetWorldInfo();

	if(WI.NetMode == NM_Client)
	{
		if (oldHealth == 0)
			oldHealth = Player.Health;
		
		if (bDeluxe)
			limit = default.critical[1];
		else
			limit = default.critical[0];
		
		if (!bOn && oldHealth > Player.Health && Player.Health >= int(float(Player.HealthMax) * limit))
		{
			oldHealth = Player.Health;
			bOn = true;
			PlayLocalEffects();
			SetTimer(default.minDelay, false, nameof(ResetEffect));
		}
		else if (!bOn && oldHealth > Player.Health)
			oldHealth = Player.Health;
	}
}

simulated function ResetEffect()
{
	bOn = false;
}

simulated function PlayLocalEffects()
{
	local vector Loc, View;
	local rotator Rot;
	local ParticleSystemComponent PSC;
	
	if(Player==none)
		Destroy();
	
	Player.PlaySoundBase(default.BlockSound, true);
	
	Loc = Player.Location;
	Rot = Player.Rotation;
	View = vector(Player.Rotation);
	
	Loc.X += 50.f*View.X;
	Loc.Y += 50.f*View.Y;
	Loc.Z += 50.f*View.Z;
	
	PSC = Player.WorldInfo.MyEmitterPool.SpawnEmitter(default.PSShield, Loc,  Rot);
		PSC.SetDepthPriorityGroup(SDPG_Foreground);
}

defaultproperties
{
   bOnlyRelevantToOwner = true
   bOn = false
   minDelay = 1.000000
   oldHealth = 0
   critical(0) = 0.900000
   critical(1) = 0.700000
   bDeluxe = false
   PSShield=ParticleSystem'ZedternalReborn_Resource.FX_Tank_effect'
   BlockSound=AkEvent'WW_WEP_Bullet_Impacts.Play_Parry_Metal'
   Name="Default__WMUpgrade_Skill_Tank_Effect"
}
