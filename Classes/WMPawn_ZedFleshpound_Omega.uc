class WMPawn_ZedFleshpound_Omega extends KFPawn_ZedFleshpound;

var const AnimSet FleshpoundOmegaAnimSet;
var const KFPawnAnimInfo FleshpoundOmegaAnimInfo;
var const KFGameExplosion OmegaExplosionTemplate;

var const float RallyRadius;
var const ParticleSystem RallyEffect, AltRallyEffect;
var const name RallyEffectBoneName;
var const name AltRallyEffectBoneNames[2];
var const vector RallyEffectOffset, AltRallyEffectOffset;

var transient ParticleSystemComponent SpecialFXPSCs[2];
var const float ExtraAfflictionResistance, ExtraDamageResistance;

static function string GetLocalizedName()
{
	return "Fleshpound Omega";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.15f;
	bVersusZed = True;

	Mesh.AnimSets.AddItem(FleshpoundOmegaAnimSet);
	PawnAnimInfo = FleshpoundOmegaAnimInfo;

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

simulated function ANIMNOTIFY_OmegaKick()
{
	local vector ExploLocation;

	Mesh.GetSocketWorldLocationAndRotation('RightMG3_socket', ExploLocation);
	TriggerOmegaExplosion(ExploLocation);
}

simulated function TriggerOmegaExplosion(vector ExploLocation)
{
	local KFExplosionActor ExploActor;

	// Boom
	ExploActor = Spawn(class'KFExplosionActor', self, , ExploLocation);
	ExploActor.InstigatorController = Controller;
	ExploActor.Instigator = self;
	ExploActor.Explode(OmegaExplosionTemplate, vect(0,0,1));
}

simulated function bool SetEnraged(bool bNewEnraged)
{
	// Fleshpound Omega will rally nearby zeds (and self) while enraging
	if (!bIsEnraged)
		RallyZeds();

	return super.SetEnraged(bNewEnraged);
}

simulated function RallyZeds()
{
	local KFPawn_Monster KFPM;
	local sRallyInfo NewRallyInfo;
	local WMGameReplicationInfo WMGRI;

	// Rally nearby zeds
	foreach WorldInfo.GRI.VisibleCollidingActors(class'KFPawn_Monster', KFPM, RallyRadius, Location)
	{
		if (KFPM.IsHeadless() || !KFPM.IsAliveAndWell() || WMPawn_ZedFleshpound_Omega(KFPM) != None)
		{
			continue;
		}
		//Force this ZEDs to sprint
		// Set Rally setting
		WMGRI = WMGameReplicationInfo(class'WorldInfo'.static.GetWorldInfo().GRI);
		if (WMGRI != None)
		{
			NewRallyInfo = KFPM.DifficultySettings.static.GetRallySettings(KFPM, WMGRI);
			NewRallyInfo.bCanRally = True;
			NewRallyInfo.bCauseSprint = True;
			KFPM.SetRallySettings(NewRallyInfo);
		}
		// Activate buffs and effects
		KFPM.Rally(self,
					RallyEffect,
					RallyEffectBoneName,
					RallyEffectOffset,
					AltRallyEffect,
					AltRallyEffectBoneNames,
					AltRallyEffectOffset);
	}
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
	FleshpoundOmegaAnimSet=AnimSet'ZedternalReborn_Zeds.Fleshpound.Fleshpound_Omega_AnimSet'
	FleshpoundOmegaAnimInfo=KFPawnAnimInfo'ZedternalReborn_Zeds.Fleshpound.Fleshpound_Omega_AnimGroup'
	OmegaExplosionTemplate=KFGameExplosion'KFGameContent.Default__KFPawn_ZedFleshpoundKing:ExploTemplate1'
	RallyRadius=1750.0f
	RallyEffect=ParticleSystem'ZedternalReborn_Zeds.Fleshpound.FX_Fleshpound_Rage_01'
	AltRallyEffect=ParticleSystem'ZedternalReborn_Zeds.Fleshpound.FX_Fleshpound_Buff_01'
	RallyEffectBoneName="Root"
	AltRallyEffectBoneNames(0)="FX_EYE_L"
	AltRallyEffectBoneNames(1)="FX_EYE_R"
	RallyEffectOffset=(X=0.0f,Y=0.0f,Z=0.0f)
	AltRallyEffectOffset=(X=0.0f,Y=0.0f,Z=0.0f)

	DefaultGlowColor=(G=0.25f)
	FootstepCameraShakeInnerRadius=230.0f
	FootstepCameraShakeOuterRadius=1035.0f

	bVersusZed=False
	DoshValue=400
	Health=4000
	Mass=220.0f
	GroundSpeed=460.0f
	SprintSpeed=615.0f
	ExtraAfflictionResistance=0.35f
	ExtraDamageResistance=0.2f

	Begin Object Name=MeleeHelper_0
		BaseDamage=30.0f
		MaxHitRange=260.0f
		MomentumTransfer=65000.0f
	End Object

	XPValues(0)=70
	XPValues(1)=94
	XPValues(2)=126
	XPValues(3)=144

	HitZones(0)=(GoreHealth=1950)

	Name="Default__WMPawn_ZedFleshpound_Omega"
}
