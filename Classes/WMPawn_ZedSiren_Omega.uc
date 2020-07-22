class WMPawn_ZedSiren_Omega extends KFPawn_ZedSiren;

var transient Zed_Arch_SirenOmega ZedArch;
var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;
var linearColor omegaColor, omegaFresnelColor;

static function string GetLocalizedName()
{
	return "Siren Omega";
}

function PossessedBy( Controller C, bool bVehicleTransition )
{
	local string NPCName;
	
	super.PossessedBy( C, bVehicleTransition );
	
	if( MyKFAIC != none && MyKFAIC.PlayerReplicationInfo != None )
	{
		NPCName = GetLocalizedName();
		PlayerReplicationInfo.PlayerName = NPCName;
		MyKFAIC.PlayerReplicationInfo.PlayerName = NPCName;
	}
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 0.920000;
	
	ZedArch = class'Zed_Arch_SirenOmega'.static.GetArch(WorldInfo);
	if (ZedArch!=none)
		updateArch();
	
	if (WorldInfo.NetMode != NM_DedicatedServer)
		ApplySpecialFX();
	
	bVersusZed = true;
	
	super.PostBeginPlay();
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
		SpecialFXPSCs[0] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'ZedternalReborn_Zeds.FX_Omega', Mesh, 'FX_EYE_L', true, vect(0,0,0) );
			
	SocketBoneName = Mesh.GetSocketBoneName('FX_EYE_R');
	if (SocketBoneName != '' && SocketBoneName != 'None')
		SpecialFXPSCs[1] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'ZedternalReborn_Zeds.FX_Omega', Mesh, 'FX_EYE_R', true, vect(0,0,0) );
}

simulated function EndSpecialFX()
{
	if( SpecialFXPSCs[0] != none && SpecialFXPSCs[0].bIsActive )
	{
		SpecialFXPSCs[0].DeactivateSystem();
	}
	if( SpecialFXPSCs[1] != none && SpecialFXPSCs[1].bIsActive )
	{
		SpecialFXPSCs[1].DeactivateSystem();
	}
}
function SetSprinting( bool bNewSprintStatus )
{
	
	if (Health == HealthMax)
		super.SetSprinting(false);
	else
		super.SetSprinting(bNewSprintStatus);
}

simulated function updateArch()
{
	ZedArch = class'Zed_Arch_SirenOmega'.Static.GetArch(WorldInfo);
	if (ZedArch != None)
	{
		Mesh.AnimSets = ZedArch.zedClientArch.AnimSets;
		Mesh.SetAnimTreeTemplate(ZedArch.zedClientArch.AnimTreeTemplate);
		PawnAnimInfo = ZedArch.zedClientArch.AnimArchetype;

		// update texture effects
		UpdateGameplayMICParams();
	}
}

simulated function UpdateGameplayMICParams()
{
	local byte i;

	super.UpdateGameplayMICParams();

	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', omegaColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', omegaColor);
		}
	}
}

/** Returns damage multiplier for an incoming damage type @todo: c++?*/
function float GetDamageTypeModifier(class<DamageType> DT)
{
	local float currentMod;

	// Omega ZEDs have extra resistance against all damage type
	currentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.f, currentMod - ExtraResistance);
}

simulated event bool UsePlayerControlledZedSkin()
{
	return true;
}

defaultproperties
{
	Begin Object Class=PointLightComponent Name=NeckLightComponentOmega
		FalloffExponent=2.f
		Brightness=0.8f
		Radius=35.f
		LightColor=(R=255,G=64,B=128,A=255)
		CastShadows=false
		bCastPerObjectShadows=false
		bEnabled=false
		LightingChannels=(Indoor=true,Outdoor=true,bInitialized=true)

		// light anim
		AnimationType=1
		AnimationFrequency=5.f
		MinBrightness=0.75f
		MaxBrightness=1.2f
	End Object
	NeckLightComponent=NeckLightComponentOmega

	bVersusZed=False

	omegaColor=(R=0.500000,G=0.250000,B=1.000000)
	omegaFresnelColor=(R=0.400000,G=0.250000,B=0.700000)

	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Siren_Omega'

	DoshValue=32
	XPValues(0)=18.000000
	XPValues(1)=24.000000
	XPValues(2)=24.000000
	XPValues(3)=26.000000

	SprintSpeed=140.000000
	GroundSpeed=290.000000
	Health=170
	ExtraResistance=0.100000
}
