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

simulated function UpdateGameplayMICParams()
{
	local byte i;

	super.UpdateGameplayMICParams();

	if ((!bIsCloaking || bIsGoreMesh) && WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Emissive Color', class'WMPawn_OmegaConstants'.default.OmegaColor);
		}
	}
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
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
