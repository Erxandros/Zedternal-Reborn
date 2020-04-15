class WMSpecialWave_SilentApproach extends WMSpecialWave;


function PostBeginPlay()
{
	SetTimer(5.f,false,nameof(UpdateSpecialWave));
	super.PostBeginPlay();
}

function UpdateSpecialWave()
{
	local KFPawn_Human KFPH;
	local WMSpecialWave_SilentApproach_Effect UPG;
	
	foreach DynamicActors(class'KFPawn_Human', KFPH)
	{
		foreach KFPH.ChildActors(class'WMSpecialWave_SilentApproach_Effect',UPG)
		{
			UPG.ClientUpdateSpecialWave();
		}
	}
	SetTimer(15.f,false,nameof(UpdateSpecialWave));
}

static simulated function InitiateWeapon(KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMSpecialWave_SilentApproach_Effect UPG;
	local bool bFound;
	
	if (KFPawn_Human(OwnerPawn)!=none)
	{
		bFound = false;
		foreach OwnerPawn.ChildActors(class'WMSpecialWave_SilentApproach_Effect',UPG)
			bFound = true;
		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMSpecialWave_SilentApproach_Effect',OwnerPawn);
	}
}

defaultproperties
{
   Title="Silent Approach"
   Description="I think my eyes are tricking me"
   zedSpawnRateFactor=0.800000
   waveValueFactor=0.800000
   doshFactor=1.220000
   
   Name="Default__WMSpecialWave_SilentApproach"
}
