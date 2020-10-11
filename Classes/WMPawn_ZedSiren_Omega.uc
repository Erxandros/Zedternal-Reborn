class WMPawn_ZedSiren_Omega extends KFPawn_ZedSiren;

var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;

static function string GetLocalizedName()
{
	return "Siren Omega";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 0.92f;
	bVersusZed = True;

	super.PostBeginPlay();

	UpdateGameplayMICParams();
	if (WorldInfo.NetMode != NM_DedicatedServer)
		ApplySpecialFX();
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
		EndSpecialFX();

	super.PlayDying(DamageType, HitLoc);
}

simulated function ApplySpecialFX()
{
	local Name SocketBoneName;

	SocketBoneName = Mesh.GetSocketBoneName('FX_EYE_L');
	if (SocketBoneName != '' && SocketBoneName != 'None')
		SpecialFXPSCs[0] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(ParticleSystem'ZedternalReborn_Zeds.FX_Omega', Mesh, 'FX_EYE_L', True, vect(0,0,0));

	SocketBoneName = Mesh.GetSocketBoneName('FX_EYE_R');
	if (SocketBoneName != '' && SocketBoneName != 'None')
		SpecialFXPSCs[1] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(ParticleSystem'ZedternalReborn_Zeds.FX_Omega', Mesh, 'FX_EYE_R', True, vect(0,0,0));
}

simulated function EndSpecialFX()
{
	if(SpecialFXPSCs[0] != None && SpecialFXPSCs[0].bIsActive)
	{
		SpecialFXPSCs[0].DeactivateSystem();
	}
	if(SpecialFXPSCs[1] != None && SpecialFXPSCs[1].bIsActive)
	{
		SpecialFXPSCs[1].DeactivateSystem();
	}
}
function SetSprinting(bool bNewSprintStatus)
{

	if (Health == HealthMax)
		super.SetSprinting(False);
	else
		super.SetSprinting(bNewSprintStatus);
}

simulated function UpdateGameplayMICParams()
{
	local byte i;

	super.UpdateGameplayMICParams();

	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', class'WMPawn_OmegaConstants'.default.OmegaColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', class'WMPawn_OmegaConstants'.default.OmegaFresnelColor);
		}
	}
}

function float GetDamageTypeModifier(class<DamageType> DT)
{
	local float currentMod;

	// Omega ZEDs have extra resistance against all damage type
	currentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.f, currentMod - ExtraResistance);
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
	Begin Object Class=PointLightComponent Name=NeckLightComponentOmega
		FalloffExponent=2.f
		Brightness=0.8f
		Radius=35.f
		LightColor=(R=255,G=64,B=128,A=255)
		CastShadows=False
		bCastPerObjectShadows=False
		bEnabled=False
		LightingChannels=(Indoor=True,Outdoor=True,bInitialized=True)

		// light anim
		AnimationType=1
		AnimationFrequency=5.f
		MinBrightness=0.75f
		MaxBrightness=1.2f
	End Object
	NeckLightComponent=NeckLightComponentOmega

	bVersusZed=False

	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Siren_Omega'

	DoshValue=32
	XPValues(0)=22
	XPValues(1)=30
	XPValues(2)=30
	XPValues(3)=30

	SprintSpeed=140.0f
	GroundSpeed=290.0f
	Health=170
	ExtraResistance=0.1f
}
