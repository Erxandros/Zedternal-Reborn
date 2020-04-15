class WMPawn_ZedFleshpound_Predator extends KFPawn_ZedFleshpound;

var linearColor predatorColor;

static function string GetLocalizedName()
{
	return "Fleshpound Predator";
}

simulated function PostBeginPlay()
{
	Mesh.SetScale(1.30);
}

simulated function UpdateGameplayMICParams()
{
	local byte i;
	
	super.UpdateGameplayMICParams();
	
	if(IsAliveAndWell() && WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i=0; i<CharacterMICs.length; i++)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', predatorColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', predatorColor);
		}
	}
}

function bool CanBeGrabbed(KFPawn GrabbingPawn, optional bool bIgnoreFalling, optional bool bAllowSameTeamGrab)
{
	return false;
}

defaultproperties
{
   DefaultGlowColor=(R=1.000000,G=0.250000,B=0.000000,A=1.000000)
   EnragedGlowColor=(R=1.000000,G=0.000000,B=0.000000,A=1.000000)
   DeadGlowColor=(R=0.000000,G=0.000000,B=0.000000,A=1.000000)
   RageBumpDamageType=Class'kfgamecontent.KFDT_HeavyZedBump'

   ControllerClass=Class'Zedternal.WMAIController_ZedFleshpound_Predator'
   bVersusZed=True
   predatorColor=(R=0.200000,G=1.000000,B=0.100000,A=1.000000)
   
   DoshValue=0
   XPValues(0)=20.000000
   XPValues(1)=25.000000
   XPValues(2)=25.000000
   XPValues(3)=30.000000

   FootstepCameraShakeInnerRadius=230.000000
   FootstepCameraShakeOuterRadius=1035.000000

   HitZones(0)=(GoreHealth=9999)
   SprintSpeed=660.000000
   Mass=250.000000
   GroundSpeed=500.000000
   Health=9999
   Name="Default__WMPawn_ZedFleshpound_Predator"
   ObjectArchetype=KFPawn_Monster'KFGameContent.Default__KFPawn_ZedFleshpound'
}
