class WMPawn_ZedFleshpound_Predator extends KFPawn_ZedFleshpound;

var linearColor PredatorColor;

static function string GetLocalizedName()
{
	return super.GetLocalizedName() @ class'ZedternalReborn.WMPawn_ZedConstants'.default.PredatorString;
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.3f;
	bVersusZed = True;

	super.PostBeginPlay();

	UpdateGameplayMICParams();
}

simulated function UpdateGameplayMICParams()
{
	local byte i;

	super.UpdateGameplayMICParams();

	if(IsAliveAndWell() && WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', PredatorColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', PredatorColor);
		}
	}
}

function bool CanBeGrabbed(KFPawn GrabbingPawn, optional bool bIgnoreFalling, optional bool bAllowSameTeamGrab)
{
	return False;
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
	ControllerClass=Class'ZedternalReborn.WMAIController_ZedFleshpound_Predator'

	DefaultGlowColor=(G=0.25f)
	PredatorColor=(R=0.2f,G=1.0f,B=0.1f)
	FootstepCameraShakeInnerRadius=230.0f
	FootstepCameraShakeOuterRadius=1035.0f

	bVersusZed=False
	DoshValue=0
	Health=9999
	Mass=250.0f
	GroundSpeed=500.0f
	SprintSpeed=660.0f

	Begin Object Name=PointLightComponent1
		LightColor=(R=50,G=255,B=25,A=255)
	End Object

	XPValues(0)=20
	XPValues(1)=25
	XPValues(2)=25
	XPValues(3)=30

	HitZones(0)=(GoreHealth=9999)

	Name="Default__WMPawn_ZedFleshpound_Predator"
}
