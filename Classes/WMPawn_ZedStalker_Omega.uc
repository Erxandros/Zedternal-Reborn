class WMPawn_ZedStalker_Omega extends KFPawn_ZedStalker;

var transient Zed_Arch_StalkerOmega ZedArch;
var linearColor omegaColor, omegaFresnelColor;

static function string GetLocalizedName()
{
	return "Stalker Omega";
}

simulated function PostBeginPlay()
{
	ZedArch = class'Zed_Arch_StalkerOmega'.static.GetArch(WorldInfo);
	if (ZedArch!=none)
		updateArch();
	
	bVersusZed = true;
	
	super.PostBeginPlay();
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

simulated function updateArch()
{
	ZedArch = class'Zed_Arch_StalkerOmega'.Static.GetArch(WorldInfo);
	if(ZedArch!=None)
	{
		Mesh.AnimSets = ZedArch.zedClientArch.AnimSets;
		Mesh.SetAnimTreeTemplate(ZedArch.zedClientArch.AnimTreeTemplate);
		PawnAnimInfo = ZedArch.zedClientArch.AnimArchetype;
		
		// update texture effects
		UpdateGameplayMICParams();
	}
}

/** Handle cloaking materials */
simulated function UpdateGameplayMICParams()
{
	local bool bIsSpotted;
	local byte i;

	//super.UpdateGameplayMICParams();
	
	// Cannot cloak after stalker has been gored
	if ( !bIsGoreMesh && WorldInfo.NetMode != NM_DedicatedServer )
	{
		// visible by local player or team (must go after ServerCallOutCloaking)
		bIsSpotted = (bIsCloakingSpottedByLP || bIsCloakingSpottedByTeam);

		if ( bIsSpotted && bIsCloaking )
		{
			Mesh.SetMaterial(0, SpottedMaterial);
		}
		else if( Mesh.SkeletalMesh.Materials[0] == SpottedMaterial )
		{
			for (i=0; i<ZedArch.zedClientArch.PlayerControlledSkins.length; i++)
			{
				Mesh.SetMaterial(i, ZedArch.zedClientArch.PlayerControlledSkins[i]);
			}
			PlayStealthSoundLoop();
		}
	}
	else if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i=0; i<CharacterMICs.length; i++)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', omegaColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', omegaColor);
		}
	}
}

static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}

simulated event bool UsePlayerControlledZedSkin()
{
    return true;
}

defaultproperties
{
   SpottedMaterial=MaterialInstanceConstant'ZED_Stalker_MAT.ZED_Stalker_Visible_MAT'
   CloakPercent=1.000000
   CloakSpeed=4.000000
   DeCloakSpeed=4.500000
   DoshValue=22
   XPValues(0)=11.000000
   XPValues(1)=14.000000
   XPValues(2)=14.000000
   XPValues(3)=16.000000
   DifficultySettings=Class'Zedternal.WMDifficulty_Stalker'
   PenetrationResistance=0.800000
   SprintSpeed=565.000000
   
   bVersusZed=False
   
   Mass=55.000000
   GroundSpeed=425.000000
   Health=250
   HitZones(0)=(GoreHealth=100)
   
   omegaColor=(R=0.500000,G=0.250000,B=1.000000)
   omegaFresnelColor=(R=0.400000,G=0.250000,B=0.700000)
   
   Name="Default__WMPawn_ZedStalker_Omega"
}
