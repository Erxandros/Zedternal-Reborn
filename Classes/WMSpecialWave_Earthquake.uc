class WMSpecialWave_Earthquake extends WMSpecialWave;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(14.0f, True, NameOf(Earthquake));
}

function Earthquake()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (FRand() < 0.8f && KFM.CanDoSpecialMove(SM_Knockdown))
			KFM.Knockdown(KFM.Velocity, vect(1, 1, 1), KFM.Location, 1000, 100);
		else if (KFM.CanDoSpecialMove(SM_Stumble))
			KFM.DoSpecialMove(SM_Stumble, , , class'KFSM_Stumble'.static.PackRandomSMFlags(KFM));
	}

	ApplyEffect();
}

function ApplyEffect()
{
	local KFPawn_Human KFPH;
	local WMSpecialWave_Earthquake_Helper UPG;

	foreach DynamicActors(class'KFPawn_Human', KFPH)
	{
		foreach KFPH.ChildActors(class'WMSpecialWave_Earthquake_Helper', UPG)
		{
			UPG.PlayLocalEffects();
			break;
		}
	}
}

static simulated function InitiateWeapon(KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMSpecialWave_Earthquake_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMSpecialWave_Earthquake_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMSpecialWave_Earthquake_Helper', OwnerPawn);
	}
}

defaultproperties
{
	WaveValueFactor=1.05f

	Title="Earthquake"
	Description="The world is now shaking"

	Name="Default__WMSpecialWave_Earthquake"
}
