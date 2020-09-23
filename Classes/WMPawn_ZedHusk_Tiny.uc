class WMPawn_ZedHusk_Tiny extends KFPawn_ZedHusk;

var linearColor glowColor;

static function string GetLocalizedName()
{
	return "Tiny Husk";
}

/** Gets the actual classes used for spawning. Can be overridden to replace this monster with another */
static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	super.PossessedBy(C, bVehicleTransition);
	if (KFAIController_ZedHusk(C) != none)
		KFAIController_ZedHusk(C).RequiredHealthPercentForSuicide = 1.0f;
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 0.700000;
	UpdateGameplayMICParams();
}

simulated function UpdateGameplayMICParams()
{
	local byte i;

	super.UpdateGameplayMICParams();

	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', default.glowColor);
		}
	}
}

defaultproperties
{
	glowColor=(R=1.000000, G=1.000000, B=1.000000)
	Begin Object Class=WMExplosion_TinyHusk Name=TinyExploTemplate0
	End Object
	ExplosionTemplate=TinyExploTemplate0
	GroundSpeed=480.000000
	SprintSpeed=480.000000
	Health=225

	Name="Default__WMPawn_ZedHusk_Tiny"
}
