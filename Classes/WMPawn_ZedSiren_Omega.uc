class WMPawn_ZedSiren_Omega extends KFPawn_ZedSiren;

var transient Zed_Arch_SirenOmega ZedArch;
var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;

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
		SpecialFXPSCs[0] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'ZED_Omega.FX_Omega', Mesh, 'FX_EYE_L', true, vect(0,0,0) );
			
	SocketBoneName = Mesh.GetSocketBoneName('FX_EYE_R');
	if (SocketBoneName != '' && SocketBoneName != 'None')
		SpecialFXPSCs[1] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'ZED_Omega.FX_Omega', Mesh, 'FX_EYE_R', true, vect(0,0,0) );
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
	local KFCharacterInfo_Monster KFCI;
	local byte i;
	
	ZedArch = class'Zed_Arch_SirenOmega'.Static.GetArch(WorldInfo);
	if(ZedArch!=None)
	{
		Mesh.SetSkeletalMesh(ZedArch.zedClientArch.CharacterMesh);
		
		for (i=0; i<ZedArch.zedClientArch.PlayerControlledSkins.length; i++)
		{
			Mesh.SetMaterial(i, ZedArch.zedClientArch.PlayerControlledSkins[i]);
		}
		KFCI = GetCharacterMonsterInfo();
		KFCI.GoreMesh = ZedArch.zedClientArch.GoreMesh;
		for (i=0; i<ZedArch.zedClientArch.PlayerControlledGoreSkins.length; i++)
		{
			KFCI.PlayerControlledGoreSkins[i] = ZedArch.zedClientArch.PlayerControlledGoreSkins[i];
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


defaultproperties
{
   Begin Object Name=NeckLightComponent0
      Radius=35.000000
      Brightness=0.800000
      LightColor=(B=255,G=64,R=128,A=255)
      bEnabled=False
      CastShadows=False
      bCastPerObjectShadows=False
      LightingChannels=(Outdoor=True)
      MaxBrightness=1.200000
      MinBrightness=0.750000
      AnimationType=1
      AnimationFrequency=5.000000
      Name="NeckLightComponent0"
      ObjectArchetype=PointLightComponent'Engine.Default__PointLightComponent'
   End Object
   NeckLightComponent=NeckLightComponent0
  
   bVersusZed=False
  
   DifficultySettings=Class'Zedternal.WMDifficulty_Siren_Omega'
  
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
