class WMPawn_ZedHusk_Tiny extends KFPawn_ZedHusk;

var linearColor glowColor;

static function string GetLocalizedName()
{
	return "Tiny Husk";
}

static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	super.PossessedBy(C, bVehicleTransition);

	if (KFAIController_ZedHusk(C) != None)
		KFAIController_ZedHusk(C).RequiredHealthPercentForSuicide = 1.0f;
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 0.7f;

	super.PostBeginPlay();

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
	glowColor=(R=1.0f, G=1.0f, B=1.0f)
	Begin Object Class=WMExplosion_TinyHusk Name=TinyExploTemplate0
	End Object
	ExplosionTemplate=TinyExploTemplate0
	GroundSpeed=480.0f
	SprintSpeed=480.0f
	Health=225

	Name="Default__WMPawn_ZedHusk_Tiny"
}
