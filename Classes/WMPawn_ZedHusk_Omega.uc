class WMPawn_ZedHusk_Omega extends WMPawn_ZedHusk_NoDAR;

var const AnimSet FireballBarrage;
var const KFPawnAnimInfo HuskOmegaAnimArch;

var int nbProjSuicide;
var class<KFProj_Husk_Fireball> SuicideFireballclass;

var transient Zed_Arch_HuskOmega ZedArch;
var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;
var linearColor omegaColor, omegaFresnelColor;

static function string GetLocalizedName()
{
	return "Husk Omega";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.140000;
	Mesh.AnimSets.AddItem(default.FireballBarrage);
	PawnAnimInfo = default.HuskOmegaAnimArch;
	UpdateGameplayMICParams();

	if (WorldInfo.NetMode != NM_DedicatedServer)
		ApplySpecialFX();

	bVersusZed = True;

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
	return FMax(0.01f, currentMod - ExtraResistance);
}

/** AnimNotify which launches the fireball projectile */
function ANIMNOTIFY_HuskRandomFireballAttack()
{
	local WMAIController_ZedHusk_Omega HuskAIC;
	local KFSM_Husk_FireballAttack FireballSM;

	if (MyKFAIC != None)
	{
		HuskAIC = WMAIController_ZedHusk_Omega(MyKFAIC);
		if (HuskAIC != None)
		{
			FireballSM = KFSM_Husk_FireBallAttack(SpecialMoves[SpecialMove]);
			HuskAIC.ShootFireballB(SuicideFireballclass,FireballSM.GetFireOffset());
		}
	}
}

/** Called when husk backpack is exploded or when husk suicides */
function TriggerExplosion(optional bool bIgnoreHumans)
{
	local KFExplosionActorReplicated ExploActor;
	local Controller DamageInstigator, OldController;
	local bool bExplodeOnDeath;
	local WMAIController_ZedHusk_Omega HuskAIC;
	local byte i;

	bExplodeOnDeath = WorldInfo.TimeSeconds == TimeOfDeath;

	// Only living husks can explode... and only once
	if (!bHasExploded && (!bPlayedDeath || bExplodeOnDeath))
	{
		OldController = Controller;
		bHasExploded = True;
		bHasSuicideExploded = !bIgnoreHumans;

		if (Role == ROLE_Authority)
		{
			// explode using the given template
			ExploActor = Spawn(class'KFExplosionActorReplicated', self);
			if (ExploActor != None)
			{
				DamageInstigator = (bIgnoreHumans && LastHitBy != None && KFPlayerController(LastHitBy) != None) ? LastHitBy : MyKFAIC;
				ExploActor.InstigatorController = DamageInstigator;
				ExploActor.Instigator = self;

				// Force ourselves to get hit.  These settings are not replicated,
				// but they only really make a difference on the server anyway.
				ExploActor.Attachee = self;
				if (bIgnoreHumans)
				{
					ExplosionTemplate.ActorclassToIgnoreForDamage = class'KFPawn_Human';
				}
				else
				{
					ExplosionTemplate.ActorClassToIgnoreForDamage = None;
				}

				ExploActor.Explode(ExplosionTemplate, vect(0,0,1));
			}

			HuskAIC = WMAIController_ZedHusk_Omega(MyKFAIC);
			if (!bIgnoreHumans && MyKFAIC != None && HuskAIC != None)
			{
				for (i = 0; i < nbProjSuicide; ++i)
				{
					HuskAIC.ShootRandomFireball(SuicideFireballclass);
				}
			}

			// Make sure we're dead!
			if (!bPlayedDeath || bExplodeOnDeath)
			{
				TakeRadiusDamage(DamageInstigator, 10000, ExplosionTemplate.DamageRadius, ExplosionTemplate.MyDamageType, ExplosionTemplate.MomentumTransferScale, Location, True, self);
			}
		}

		OnExploded(OldController);
	}
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
	ParryResistance=3
	SuicideFireballclass=class'ZedternalReborn.WMProj_Husk_Fireball_Suicide'
	Begin Object Name=MeleeHelper_0 Archetype=KFMeleeHelperAI'KFGame.Default__KFPawn_Monster:MeleeHelper_0'
		BaseDamage=20.000000
		MyDamageType=class'kfgamecontent.KFDT_Slashing_ZedWeak'
		MomentumTransfer=30000.000000
		MaxHitRange=180.000000
		Name="MeleeHelper_0"
	End Object
	DoshValue=34
	XPValues(0)=30.000000
	XPValues(1)=40.000000
	XPValues(2)=54.000000
	XPValues(3)=62.000000
	SprintSpeed=580.000000
	GroundSpeed=230.000000
	Health=820
	ExtraResistance=0.200000

	omegaColor=(R=0.500000,G=0.250000,B=1.000000)
	omegaFresnelColor=(R=0.400000,G=0.250000,B=0.700000)

	FireballBarrage=AnimSet'ZedternalReborn_Zeds.Husk_Omega_Anim_Master'
	HuskOmegaAnimArch=KFPawnAnimInfo'ZedternalReborn_Zeds.Husk_Omega_AnimGroup'

	DifficultySettings=class'ZedternalReborn.WMDifficulty_Husk_Omega'
	LocalizationKey="WMPawn_ZedHusk_Omega"
	HitZones(0)=(GoreHealth=430,DmgScale=1.001000)
	HitZones(1)=()
	HitZones(2)=()
	HitZones(3)=(GoreHealth=180,DmgScale=1.500000,SkinID=2)
	PenetrationResistance=3.000000
	bVersusZed=False
	nbProjSuicide=12;
	Controllerclass=class'ZedternalReborn.WMAIController_ZedHusk_Omega'
	Begin Object Name=KFPawnSkeletalMeshComponent Archetype=KFSkeletalMeshComponent'KFGame.Default__KFPawn_Monster:KFPawnSkeletalMeshComponent'
		WireframeColor=(B=0,G=255,R=255,A=255)
		MinDistFactorForKinematicUpdate=0.200000
		bSkipAllUpdateWhenPhysicsAsleep=True
		bIgnoreControllersWhenNotRendered=True
		bHasPhysicsAssetInstance=True
		bUpdateKinematicBonesFromAnimation=False
		bPerBoneMotionBlur=True
		bOverrideAttachmentOwnerVisibility=True
		bChartDistanceFactor=True
		ReplacementPrimitive=None
		RBChannel=RBCC_Pawn
		RBDominanceGroup=20
		bOwnerNoSee=True
		bAcceptsDynamicDecals=True
		bUseOnePassLightingOnTranslucency=True
		CollideActors=True
		BlockZeroExtent=True
		BlockRigidBody=True
		RBCollideWithChannels=(Default=True,Pawn=True,Vehicle=True,BlockingVolume=True)
		Translation=(X=0.000000,Y=0.000000,Z=-86.000000)
		ScriptRigidBodyCollisionThreshold=200.000000
		PerObjectShadowCullDistance=2500.000000
		bAllowPerObjectShadows=True
		TickGroup=TG_DuringAsyncWork
		Name="KFPawnSkeletalMeshComponent"
	End Object

	Name="Default__WMPawn_ZedHusk_Omega"
}
