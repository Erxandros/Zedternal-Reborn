class WMPawn_ZedGorefast_Omega extends WMPawn_ZedGorefast_NoDualBlade;

var transient Zed_Arch_GoreFastOmega ZedArch;
var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;

var KFSkinTypeEffects ShieldImpactEffects;
var bool bShieldOn;
var vector EffectOffset;

replication
{
    if (Role == ROLE_Authority)
        bShieldOn;
}

static function string GetLocalizedName()
{
	return "Gorefast Omega";
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
	IntendedBodyScale = 1.140000;
	ZedArch = class'Zed_Arch_GoreFastOmega'.static.GetArch(WorldInfo);
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
simulated function updateArch()
{
	ZedArch = class'Zed_Arch_GoreFastOmega'.Static.GetArch(WorldInfo);
	if(ZedArch!=None)
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
		for (i=0; i<CharacterMICs.length; i++)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', class'WMPawn_OmegaConstants'.default.OmegaColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', class'WMPawn_OmegaConstants'.default.OmegaFresnelColor);
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

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int HitZoneIdx;
	
	HitZoneIdx = HitZones.Find('ZoneName', HitInfo.BoneName);
	
	if(bShieldOn && IsIncapacitated())
		bShieldOn = false;
	
	if(bShieldOn && HitZoneIdx < 9)
	{
		Damage = Max(0, int(float(Damage) * 0.250000));
		Momentum.X *= 0.150000;
		Momentum.Y *= 0.150000;
		Momentum.Z *= 0.150000;
	}
	
	super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );
}


/** AnimNotify which turns on half-shield */
simulated function ANIMNOTIFY_TurnShieldOn()
{
	bShieldOn  = true;
	SetTimer(1.400000, false, nameof(EndShield));
}

simulated function EndShield()
{
	bShieldOn = false;
}

simulated function KFSkinTypeEffects GetHitZoneSkinTypeEffects( int HitZoneIdx )
{
    if(bShieldOn && HitZoneIdx < 9)
	{
        return ShieldImpactEffects;
	}
    else
        return super.GetHitZoneSkinTypeEffects( HitZoneIdx );
}

simulated function ApplyBloodDecals(int HitZoneIndex, vector HitLocation, vector HitDirection, name HitZoneName, name HitBoneName, class<KFDamageType> DmgType, bool bIsDismemberingHit, bool bWasObliterated)
{
    if(!bShieldOn || HitZoneIndex >= 9)
        super.ApplyBloodDecals( HitZoneIndex, HitLocation, HitDirection, HitZoneName, HitBoneName, DmgType, bIsDismemberingHit, bWasObliterated );

}

simulated event bool UsePlayerControlledZedSkin()
{
    return true;
}

defaultproperties
{
   bVersusZed=False
   ParryResistance=3
   
   bShieldOn=false
   EffectOffset=(X=0.000000, Y=0.000000, Z=0.000000)
   ShieldImpactEffects=KFSkinTypeEffects_InvulnerabilityShield'KFGameContent.Default__KFPawn_ZedHans:ShieldEffects'
   
   DoshValue=24
   XPValues(0)=22.000000
   XPValues(1)=28.000000
   XPValues(2)=28.000000
   XPValues(3)=28.000000
   SprintSpeed=435.000000
   GroundSpeed=285.000000
   Health=600
   ExtraResistance=0.200000

   DifficultySettings=Class'ZedternalReborn.WMDifficulty_Gorefast_Omega'

   LocalizationKey="WMPawn_ZedGorefast_Omega"

   HitZones(0)=(GoreHealth=400)
   

   PenetrationResistance=2.250000
   
   ControllerClass=Class'ZedternalReborn.WMAIController_ZedGorefast_Omega'

   Name="Default__WMPawn_ZedGorefast_Omega"
}
