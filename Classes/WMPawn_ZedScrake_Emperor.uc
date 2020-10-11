class WMPawn_ZedScrake_Emperor extends KFPawn_ZedScrake;

var const AnimSet ScrakeOmegaAnimSet;
var const KFPawnAnimInfo ScrakeOmegaAnimInfo;

static function string GetLocalizedName()
{
	return "Scrake Emperor";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.4f;
	bVersusZed = True;

	Mesh.AnimSets.AddItem(ScrakeOmegaAnimSet);
	PawnAnimInfo = ScrakeOmegaAnimInfo;

	super.PostBeginPlay();
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
	ScrakeOmegaAnimSet=AnimSet'ZedternalReborn_Zeds.Scrake.Scrake_Omega_AnimSet'
	ScrakeOmegaAnimInfo=KFPawnAnimInfo'ZedternalReborn_Zeds.Scrake.Scrake_Omega_AnimGroup'
	DifficultySettings=class'ZedternalReborn.WMDifficulty_Scrake_Emperor'
	LocalizationKey="WMPawn_ZedScrake_Emperor"

	RageHealthThresholdNormal=0.2f
	RageHealthThresholdHard=0.225f
	RageHealthThresholdSuicidal=0.25f
	RageHealthThresholdHellOnEarth=0.275f

	bVersusZed=False
	DoshValue=400
	Health=4000
	Mass=225.0f
	GroundSpeed=180.0f
	SprintSpeed=640.0f

	Begin Object Name=MeleeHelper_0
		BaseDamage=20.0f
		MomentumTransfer=60000.0f
	End Object

	XPValues(0)=75
	XPValues(1)=100
	XPValues(2)=135
	XPValues(3)=150

	HitZones(0)=(GoreHealth=3000)
	HitZones(8)=(GoreHealth=75, DmgScale=0.1f)

	Name="Default__WMPawn_ZedScrake_Emperor"
}
