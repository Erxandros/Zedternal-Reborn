class WMPawn_ZedClot_Slasher_Omega extends KFPawn_ZedClot_Slasher;

var const AnimSet SlasherOmegaAnimSet;
var const KFPawnAnimInfo SlasherOmegaAnimInfo;

var transient ParticleSystemComponent SpecialFXPSCs[2];
var const float ExtraAfflictionResistance, ExtraDamageResistance;

static function string GetLocalizedName()
{
	return "Slasher Omega";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.125f;
	bVersusZed = True;

	Mesh.AnimSets.AddItem(default.SlasherOmegaAnimSet);
	PawnAnimInfo = default.SlasherOmegaAnimInfo;

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

simulated function UpdateGameplayMICParams()
{
	local byte i;

	super.UpdateGameplayMICParams();

	if (WorldInfo.NetMode != NM_DedicatedServer)
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
	SlasherOmegaAnimSet=AnimSet'ZedternalReborn_Zeds.Slasher.Slasher_Clot_Omega_AnimSet'
	SlasherOmegaAnimInfo=KFPawnAnimInfo'ZedternalReborn_Zeds.Slasher.Slasher_Clot_Omega_AnimGroup'
	LocalizationKey="WMPawn_ZedSlasher_Omega"

	bVersusZed=False
	DoshValue=15
	Health=250
	GroundSpeed=340.0f
	SprintSpeed=580.0f
	ParryResistance=1
	ExtraAfflictionResistance=0.15f
	ExtraDamageResistance=0.15f
	GrabAttackFrequency=0.6f

	Begin Object Name=MeleeHelper_0
		BaseDamage=10.0f
		MaxHitRange=180.0f
	End Object

	XPValues(0)=16
	XPValues(1)=22
	XPValues(2)=22
	XPValues(3)=22

	HitZones(0)=(GoreHealth=150)

	Name="Default__WMPawn_ZedClot_Slasher_Omega"
}
