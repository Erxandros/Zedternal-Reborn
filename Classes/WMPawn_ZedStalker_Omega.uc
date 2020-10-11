class WMPawn_ZedStalker_Omega extends WMPawn_ZedStalker_NoDAR;

var transient Zed_Arch_StalkerOmega ZedArch;

static function string GetLocalizedName()
{
	return "Stalker Omega";
}

simulated function PostBeginPlay()
{
	ZedArch = class'Zed_Arch_StalkerOmega'.static.GetArch(WorldInfo);
	if (ZedArch != None)
		updateArch();

	bVersusZed = True;

	super.PostBeginPlay();
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	local string NPCName;

	super.PossessedBy(C, bVehicleTransition);

	if (MyKFAIC != None && MyKFAIC.PlayerReplicationInfo != None)
	{
		NPCName = GetLocalizedName();
		PlayerReplicationInfo.PlayerName = NPCName;
		MyKFAIC.PlayerReplicationInfo.PlayerName = NPCName;
	}
}

simulated function updateArch()
{
	ZedArch = class'Zed_Arch_StalkerOmega'.Static.GetArch(WorldInfo);
	if (ZedArch != None)
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
	if (!bIsGoreMesh && WorldInfo.NetMode != NM_DedicatedServer)
	{
		// visible by local player or team (must go after ServerCallOutCloaking)
		bIsSpotted = (bIsCloakingSpottedByLP || bIsCloakingSpottedByTeam);

		if (bIsSpotted && bIsCloaking)
		{
			Mesh.SetMaterial(0, SpottedMaterial);
		}
		else if (Mesh.SkeletalMesh.Materials[0] == SpottedMaterial)
		{
			for (i = 0; i < ZedArch.zedClientArch.PlayerControlledSkins.length; ++i)
			{
				Mesh.SetMaterial(i, ZedArch.zedClientArch.PlayerControlledSkins[i]);
			}
			PlayStealthSoundLoop();
		}
	}
	else if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', class'WMPawn_OmegaConstants'.default.OmegaColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', class'WMPawn_OmegaConstants'.default.OmegaFresnelColor);
		}
	}
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
	SpottedMaterial=MaterialInstanceConstant'ZED_Stalker_MAT.ZED_Stalker_Visible_MAT'
	CloakPercent=1.0f
	CloakSpeed=4.0f
	DeCloakSpeed=4.5f
	DoshValue=22
	XPValues(0)=11
	XPValues(1)=14
	XPValues(2)=14
	XPValues(3)=16
	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Stalker'
	PenetrationResistance=0.8f
	SprintSpeed=565.0f

	bVersusZed=False

	Mass=55.0f
	GroundSpeed=425.0f
	Health=250
	HitZones(0)=(GoreHealth=100)

	Name="Default__WMPawn_ZedStalker_Omega"
}
