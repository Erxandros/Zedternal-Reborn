class WMPawn_ZedStalker_Omega extends WMPawn_ZedStalker_NoDAR;

var const AnimSet StalkerOmegaAnimSet;

static function string GetLocalizedName()
{
	return "Stalker Omega";
}

simulated function PostBeginPlay()
{
	bVersusZed = True;

	//Replace the master AnimSet with the omega master AnimSet
	Mesh.AnimSets[0] = StalkerOmegaAnimSet;

	super.PostBeginPlay();

	UpdateGameplayMICParams();
}

simulated function UpdateGameplayMICParams()
{
	local byte i;

	super.UpdateGameplayMICParams();

	if ((!bIsCloaking || bIsGoreMesh) && WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Emissive Color', class'WMPawn_OmegaConstants'.default.OmegaColor);
		}
	}
}

simulated event bool UsePlayerControlledZedSkin()
{
	if (class'KFGameEngine'.static.GetSeasonalEventID() % 10 == SEI_Fall)
		return False;

	return True;
}

defaultproperties
{
	StalkerOmegaAnimSet=AnimSet'ZedternalReborn_Zeds.Stalker_Omega_Anim'
	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Stalker'

	bVersusZed=False
	DoshValue=22
	Mass=55.0f
	SprintSpeed=565.0f
	GroundSpeed=425.0f
	Health=250
	PenetrationResistance=0.8f

	XPValues(0)=11
	XPValues(1)=14
	XPValues(2)=14
	XPValues(3)=16

	HitZones(0)=(GoreHealth=100)

	Name="Default__WMPawn_ZedStalker_Omega"
}
