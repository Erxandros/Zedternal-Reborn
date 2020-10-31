Class WMUpgrade_Skill_BringTheHeat_Counter extends Info
	transient;

var KFPawn_Human Player;
var int CumulativeDamage;
var int MaxCumulativeDamage;
var int DeltaCumulativeDamage;
var float HeatWaveDelay;
var array<int> CostHeatWave;
var array< class< WMUpgrade_Skill_BringTheHeat_Flame_Base > > ClassHeatWave;
var ParticleSystem PSBuff;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
	else
		SetTimer(HeatWaveDelay, True);
}

function Timer()
{
	local byte i;

	CumulativeDamage = min(default.MaxCumulativeDamage, CumulativeDamage);

	//check if player can create heat waves
	for (i = CostHeatWave.length; i > 0; --i)
	{
		if (CumulativeDamage >= CostHeatWave[i - 1])
		{
			CumulativeDamage -= CostHeatWave[i - 1] - DeltaCumulativeDamage;
			CreateHeatWave(i - 1);
			break;
		}
	}

	CumulativeDamage = max(0, CumulativeDamage - DeltaCumulativeDamage);
}

function CreateHeatWave(byte force)
{
	local rotator Rot;
	local vector Loc;

	Rot = rotator(Player.Velocity);
	Rot.Pitch = 0;
	Loc = Player.Location;
	Loc.Z -= Player.GetCollisionHeight() - 1;

	Spawn(default.ClassHeatWave[force], Player.Controller, , Loc, Rot, ,True);

	Spawn(class'ZedternalReborn.WMFX_BringTheHeat', , , Player.Location, Rot, ,True);
}

defaultproperties
{
	CumulativeDamage=0
	MaxCumulativeDamage=2500
	DeltaCumulativeDamage=20
	HeatWaveDelay=1.0f

	CostHeatWave(0)=400
	CostHeatWave(1)=750
	CostHeatWave(2)=1500
	ClassHeatWave(0)=class'ZedternalReborn.WMUpgrade_Skill_BringTheHeat_Flame_Low'
	ClassHeatWave(1)=class'ZedternalReborn.WMUpgrade_Skill_BringTheHeat_Flame_Medium'
	ClassHeatWave(2)=class'ZedternalReborn.WMUpgrade_Skill_BringTheHeat_Flame_High'
	PSBuff=ParticleSystem'ZedternalReborn_Resource.Effects.FX_BringTheHeat_Effect'

	Name="Default__WMUpgrade_Skill_BringTheHeat_Counter"
}
