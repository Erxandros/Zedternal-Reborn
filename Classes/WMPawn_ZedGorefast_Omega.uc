class WMPawn_ZedGorefast_Omega extends WMPawn_ZedGorefast_NoDualBlade;

var const AnimSet GorefastOmegaAnimSet;
var const KFPawnAnimInfo GorefastOmegaAnimInfo;
var const KFSkinTypeEffects ShieldImpactEffects;

var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;
var bool bShieldOn;

replication
{
	if (Role == ROLE_Authority)
		bShieldOn;
}

static function string GetLocalizedName()
{
	return "Gorefast Omega";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.14f;
	bVersusZed = True;

	Mesh.AnimSets.AddItem(GorefastOmegaAnimSet);
	PawnAnimInfo = GorefastOmegaAnimInfo;

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
	local float currentMod;

	// Omega ZEDs have extra resistance against all damage type
	currentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.01f, currentMod - ExtraResistance);
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int HitZoneIdx;

	HitZoneIdx = HitZones.Find('ZoneName', HitInfo.BoneName);

	if (bShieldOn && IsIncapacitated())
		bShieldOn = False;

	if (bShieldOn && HitZoneIdx < 9)
	{
		Damage = Max(0, int(float(Damage) * 0.25f));
		Momentum.X *= 0.15f;
		Momentum.Y *= 0.15f;
		Momentum.Z *= 0.15f;
	}

	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

/** AnimNotify which turns on half-shield */
simulated function ANIMNOTIFY_TurnShieldOn()
{
	bShieldOn = True;
	SetTimer(1.4f, False, nameof(EndShield));
}

simulated function EndShield()
{
	bShieldOn = False;
}

simulated function KFSkinTypeEffects GetHitZoneSkinTypeEffects(int HitZoneIdx)
{
	if (bShieldOn && HitZoneIdx < 9)
	{
		return ShieldImpactEffects;
	}
	else
		return super.GetHitZoneSkinTypeEffects(HitZoneIdx);
}

simulated function ApplyBloodDecals(int HitZoneIndex, vector HitLocation, vector HitDirection, name HitZoneName, name HitBoneName, class<KFDamageType> DmgType, bool bIsDismemberingHit, bool bWasObliterated)
{
	if (!bShieldOn || HitZoneIndex >= 9)
		super.ApplyBloodDecals(HitZoneIndex, HitLocation, HitDirection, HitZoneName, HitBoneName, DmgType, bIsDismemberingHit, bWasObliterated);
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
	GorefastOmegaAnimSet=AnimSet'ZedternalReborn_Zeds.Gorefast.Gorefast_Omega_AnimSet'
	GorefastOmegaAnimInfo=KFPawnAnimInfo'ZedternalReborn_Zeds.Gorefast.Gorefast_Omega_AnimGroup'
	ShieldImpactEffects=KFSkinTypeEffects_InvulnerabilityShield'KFGameContent.Default__KFPawn_ZedHans:ShieldEffects'
	ControllerClass=class'ZedternalReborn.WMAIController_ZedGorefast_Omega'
	DifficultySettings=class'ZedternalReborn.WMDifficulty_Gorefast_Omega'
	LocalizationKey="WMPawn_ZedGorefast_Omega"

	bShieldOn=False
	bVersusZed=False
	DoshValue=24
	Health=600
	GroundSpeed=285.0f
	SprintSpeed=435.0f
	ParryResistance=3
	PenetrationResistance=2.25f
	ExtraResistance=0.2f

	XPValues(0)=22
	XPValues(1)=28
	XPValues(2)=28
	XPValues(3)=28

	HitZones(0)=(GoreHealth=400)

	Name="Default__WMPawn_ZedGorefast_Omega"
}
