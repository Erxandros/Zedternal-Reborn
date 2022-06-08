class WMPawn_ZedStalker_Omega extends WMPawn_ZedStalker_NoDAR;

var const AnimSet StalkerOmegaAnimSet;
var const float ExtraAfflictionResistance, ExtraDamageResistance;

static function string GetLocalizedName()
{
	return super.GetLocalizedName() @ class'ZedternalReborn.WMPawn_ZedConstants'.default.OmegaString;
}

simulated function PostBeginPlay()
{
	bVersusZed = True;

	//Replace the master AnimSet with the omega master AnimSet
	Mesh.AnimSets[0] = StalkerOmegaAnimSet;

	super.PostBeginPlay();

	UpdateGameplayMICParams();
}

simulated function UpdateGameplayMICParams()
{
	local byte i;

	super.UpdateGameplayMICParams();

	if ((!bIsCloaking || bIsGoreMesh) && WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Emissive Color', class'ZedternalReborn.WMPawn_ZedConstants'.default.OmegaColor);
		}
	}
}

simulated event bool UsePlayerControlledZedSkin()
{
	if (class'KFGameEngine'.static.GetSeasonalEventID() % 10 == SEI_Fall)
		return False;

	return True;
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

defaultproperties
{
	StalkerOmegaAnimSet=AnimSet'ZedternalReborn_Zeds.Stalker.Stalker_Omega_AnimSet'
	DifficultySettings=class'ZedternalReborn.WMDifficulty_Stalker_Omega'

	bVersusZed=False
	DoshValue=22
	Health=250
	Mass=55.0f
	GroundSpeed=425.0f
	SprintSpeed=565.0f
	PenetrationResistance=0.8f
	ExtraAfflictionResistance=0.1f
	ExtraDamageResistance=0.05f

	XPValues(0)=12
	XPValues(1)=15
	XPValues(2)=15
	XPValues(3)=15

	HitZones(0)=(GoreHealth=100)

	Name="Default__WMPawn_ZedStalker_Omega"
}
