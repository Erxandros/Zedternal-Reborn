class WMPawn_ZedSiren_Omega extends KFPawn_ZedSiren;

var transient ParticleSystemComponent SpecialFXPSCs[2];
var const float ExtraAfflictionResistance, ExtraDamageResistance;

static function string GetLocalizedName()
{
	return super.GetLocalizedName() @ class'ZedternalReborn.WMPawn_ZedConstants'.default.OmegaString;
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
	if (SpecialFXPSCs[0] != None && SpecialFXPSCs[0].bIsActive)
	{
		SpecialFXPSCs[0].DeactivateSystem();
	}
	if (SpecialFXPSCs[1] != None && SpecialFXPSCs[1].bIsActive)
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

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', class'ZedternalReborn.WMPawn_ZedConstants'.default.OmegaColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', class'ZedternalReborn.WMPawn_ZedConstants'.default.OmegaFresnelColor);
		}
	}
}

function float GetDamageTypeModifier(class<DamageType> DT)
{
	local float CurrentMod;

	// Omega ZEDs have extra resistance against all damage type
	CurrentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.025f, CurrentMod - ExtraDamageResistance);
}

simulated function AdjustAffliction(out float AfflictionPower)
{
	super.AdjustAffliction(AfflictionPower);
	AfflictionPower *= 1.0f - ExtraAfflictionResistance;
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Siren_Omega'

	bVersusZed=False
	DoshValue=50
	Health=275
	GroundSpeed=180.0f
	SprintSpeed=245.0f
	ExtraAfflictionResistance=0.2f
	ExtraDamageResistance=0.1f

	Begin Object Name=NeckLightComponent0
		LightColor=(R=127,G=63,B=255,A=255)
	End Object

	XPValues(0)=22
	XPValues(1)=30
	XPValues(2)=30
	XPValues(3)=30

	HitZones(0)=(GoreHealth=180)

	Name="Default__WMPawn_ZedSiren_Omega"
}
