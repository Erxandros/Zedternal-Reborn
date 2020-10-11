class WMPawn_ZedHusk_Omega extends WMPawn_ZedHusk_NoDAR;

var const AnimSet FireballBarrage;
var const class<KFProj_Husk_Fireball> SuicideFireballClass;
var const int ProjSuicideAmount;

var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;

static function string GetLocalizedName()
{
	return "Husk Omega";
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	local KFGameReplicationInfo KFGRI;

	super(KFPawn_Monster).PossessedBy(C, bVehicleTransition);

	// Set our difficulty-based settings
	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	if(KFGRI != None)
	{
		FireballSettings = class<KFDifficulty_Husk>(DifficultySettings).static.GetFireballSettings(self, KFGRI);
	}
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.14f;
	bVersusZed = True;
	Mesh.AnimSets.AddItem(default.FireballBarrage);

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

/** AnimNotify which launches the fireball projectile */
function ANIMNOTIFY_HuskRandomFireballAttack()
{
	local WMAIController_ZedHusk_Omega HuskAIC;
	local WMSM_Husk_Omega_FireBallBarrageAttack FireballBarrageSM;

	if (MyKFAIC != None)
	{
		HuskAIC = WMAIController_ZedHusk_Omega(MyKFAIC);
		if (HuskAIC != None)
		{
			FireballBarrageSM = WMSM_Husk_Omega_FireBallBarrageAttack(SpecialMoves[SpecialMove]);
			HuskAIC.ShootFireballBarrage(default.SuicideFireballClass, FireballBarrageSM.GetFireOffset());
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
					ExplosionTemplate.ActorClassToIgnoreForDamage = class'KFPawn_Human';
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
				for (i = 0; i < ProjSuicideAmount; ++i)
				{
					HuskAIC.ShootRandomFireball(default.SuicideFireballClass);
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
	FireballBarrage=AnimSet'ZedternalReborn_Zeds.Husk_Omega_Anim_Master'
	SuicideFireballClass=class'ZedternalReborn.WMProj_Husk_Fireball_Suicide'
	ControllerClass=class'ZedternalReborn.WMAIController_ZedHusk_Omega'
	DifficultySettings=class'ZedternalReborn.WMDifficulty_Husk_Omega'
	LocalizationKey="WMPawn_ZedHusk_Omega"

	bVersusZed=False
	DoshValue=34
	Health=820
	GroundSpeed=230.0f
	SprintSpeed=580.0f
	ParryResistance=3
	PenetrationResistance=3.0f
	ExtraResistance=0.2f
	ProjSuicideAmount=12;

	Begin Object Name=MeleeHelper_0
		BaseDamage=20.0f
		MomentumTransfer=30000.0f
	End Object

	Begin Object Name=SpecialMoveHandler_0
		SpecialMoveClasses(SM_Custom1) = class'ZedternalReborn.WMSM_Husk_Omega_FireBallBarrageAttack'
	End Object

	XPValues(0)=30
	XPValues(1)=40
	XPValues(2)=54
	XPValues(3)=62

	HitZones(0)=(GoreHealth=430)
	HitZones(3)=(GoreHealth=180)

	Name="Default__WMPawn_ZedHusk_Omega"
}
