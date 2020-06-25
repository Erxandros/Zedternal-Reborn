class WMSpecialWave_Earthquake extends WMSpecialWave;

function PostBeginPlay()
{
	SetTimer(14.f,true,nameof(Earthquake));
	super.PostBeginPlay();
}

function Earthquake()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if( FRand() < 0.800000 && KFM.CanDoSpecialMove( SM_Knockdown ) )
			KFM.Knockdown( KFM.Velocity, vect(1,1,1), KFM.Location, 1000, 100 );
		else if ( KFM.CanDoSpecialMove( SM_Stumble ))
			KFM.DoSpecialMove(SM_Stumble,,, class'KFSM_Stumble'.static.PackRandomSMFlags(KFM));
	}
	ApplyEffect();
}

function ApplyEffect()
{
	local KFPawn_Human KFPH;
	local WMSpecialWave_Earthquake_Effect UPG;

	foreach DynamicActors(class'KFPawn_Human', KFPH)
	{
		foreach KFPH.ChildActors(class'WMSpecialWave_Earthquake_Effect',UPG)
		{
			UPG.PlayLocalEffects();
		}
	}
}

static simulated function InitiateWeapon(KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMSpecialWave_Earthquake_Effect UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn)!=none)
	{
		bFound = false;
		foreach OwnerPawn.ChildActors(class'WMSpecialWave_Earthquake_Effect',UPG)
			bFound = true;
		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMSpecialWave_Earthquake_Effect',OwnerPawn);
	}
}

defaultproperties
{
	Title="Earthquake"
	Description="The world is now shaking"
	zedSpawnRateFactor=1.000000
	waveValueFactor=1.050000
	doshFactor=1.000000

	Name="Default__WMSpecialWave_Earthquake"
}
