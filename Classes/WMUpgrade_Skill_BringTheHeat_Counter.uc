Class WMUpgrade_Skill_BringTheHeat_Counter extends Info
	transient;

var KFPawn_Human Player;
var int cumulDamage;
var int deltaCumul;
var int maxCumulDamage;
var float heatWaveDelay;
var array< int > costHeatWave;
var array< class< WMUpgrade_Skill_BringTheHeat_Flame_Base > > classHeatWave;
var float fireBonus;
var ParticleSystem PSBuff;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
	else
		SetTimer(heatWaveDelay, True);
}

function Timer()
{
	local byte i;

	cumulDamage = min(maxCumulDamage, cumulDamage);

	//check if player can create heat waves
	for (i = costHeatWave.length; i > 0; --i)
	{
		if (cumulDamage >= costHeatWave[i - 1])
		{
			cumulDamage -= costHeatWave[i - 1] - deltaCumul;
			CreateHeatWave(i - 1);
			i = 1;
		}
	}

	cumulDamage = max(0,cumulDamage - deltaCumul);
}

function CreateHeatWave(byte force)
{
	local rotator Rot;
	local vector Loc;

	Rot = rotator(Player.Velocity);
	Rot.Pitch = 0;
	Loc = Player.Location;
	Loc.Z -= Player.GetCollisionHeight() - 1;

	Spawn(default.classHeatWave[force], Player.Controller, , Loc, Rot, ,True);

	//CreateClientHeatWave(force, Player);
	Spawn(class'ZedternalReborn.WMFX_BringTheHeat', , , Player.Location, Rot, ,True);
}

reliable client function CreateClientHeatWave(byte force, KFPawn_Human KFOwner)
{
	local rotator Rot;
	local ParticleSystemComponent PSC;

	Rot = rotator(KFOwner.Velocity);
	Rot.Pitch = 0;

	PSC = KFOwner.WorldInfo.MyEmitterPool.SpawnEmitter(default.PSBuff, KFOwner.Location, Rot);
	PSC.SetDepthPriorityGroup(SDPG_Foreground);
}

defaultproperties
{
	fireBonus=1.4f
	cumulDamage=0
	maxCumulDamage=2500
	deltaCumul=20
	heatWaveDelay=1.0f
	costHeatWave(0)=400
	costHeatWave(1)=750
	costHeatWave(2)=1500
	classHeatWave(0)=class'ZedternalReborn.WMUpgrade_Skill_BringTheHeat_Flame_Low'
	classHeatWave(1)=class'ZedternalReborn.WMUpgrade_Skill_BringTheHeat_Flame_Medium'
	classHeatWave(2)=class'ZedternalReborn.WMUpgrade_Skill_BringTheHeat_Flame_High'
	PSBuff=ParticleSystem'ZedternalReborn_Resource.Effects.FX_BringTheHeat_Effect'
	Name="Default__WMUpgrade_Skill_BringTheHeat_Counter"
}
