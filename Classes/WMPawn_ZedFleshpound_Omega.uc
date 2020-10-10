class WMPawn_ZedFleshpound_Omega extends KFPawn_ZedFleshpound;

var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;

var const float RallyRadius;
var const ParticleSystem RallyEffect, AltRallyEffect;
var const name RallyEffectBoneName;
var const name AltRallyEffectBoneNames[2];
var const vector RallyEffectOffset, AltRallyEffectOffset;

var const KFGameExplosion OmegaExplosionTemplate;
var const AnimSet FleshpoundOmegaAnimSet;
var const KFPawnAnimInfo FleshpoundOmegaAnimInfo;

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
	local float currentMod;

	// Omega ZEDs have extra resistance against all damage type
	currentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.01f, currentMod - ExtraResistance);
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
	DefaultGlowColor=(R=1.0f,G=0.25f,B=0.0f,A=1.0f)
	EnragedGlowColor=(R=1.0f,G=0.0f,B=0.0f,A=1.0f)
	DeadGlowColor=(R=0.0f,G=0.0f,B=0.0f,A=1.0f)
	RageBumpDamageType=class'KFGameContent.KFDT_HeavyZedBump'

	bVersusZed=False

	RallyRadius=1750.0f
	RallyEffect=ParticleSystem'ZedternalReborn_Zeds.FX_Fleshpound_Rage_01'
	AltRallyEffect=ParticleSystem'ZedternalReborn_Zeds.FX_Fleshpound_Buff_01'
	RallyEffectBoneName="Root"
	AltRallyEffectBoneNames(0)="FX_EYE_L"
	AltRallyEffectBoneNames(1)="FX_EYE_R"
	RallyEffectOffset=(X=0.0f,Y=0.0f,Z=0.0f)
	AltRallyEffectOffset=(X=0.0f,Y=0.0f,Z=0.0f)

	DoshValue=400
	XPValues(0)=70
	XPValues(1)=94
	XPValues(2)=126
	XPValues(3)=144
	Health=4000
	ExtraResistance=0.2f
	GroundSpeed=460.0f
	SprintSpeed=615.0f

	FootstepCameraShakeInnerRadius=230.0f
	FootstepCameraShakeOuterRadius=1035.0f

	LocalizationKey="WMPawn_ZedFleshpound_Omega"

	HitZones(0)=(GoreHealth=1950)

	OmegaExplosionTemplate=KFGameExplosion'KFGameContent.Default__KFPawn_ZedFleshpoundKing:ExploTemplate1'
	FleshpoundOmegaAnimSet=AnimSet'ZedternalReborn_Zeds.Fleshpound_Omega_Anim'
	FleshpoundOmegaAnimInfo=KFPawnAnimInfo'ZedternalReborn_Zeds.Fleshpound_Omega_AnimGroup'

	Mass=220.0f
	Begin Object Class=KFMeleeHelperAI Name=WMMeleeHelper_0
		BaseDamage=30.0f
		MyDamageType=class'KFGameContent.KFDT_Bludgeon_Fleshpound'
		MomentumTransfer=65000.0f
		MaxHitRange=260.0f
	End Object
	MeleeAttackHelper=WMMeleeHelper_0

	Name="Default__WMPawn_ZedFleshpound_Omega"
}
