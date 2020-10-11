class WMPawn_ZedScrake_Emperor extends KFPawn_ZedScrake;

var transient Zed_Arch_ScrakeOmega ZedArch;

static function string GetLocalizedName()
{
	return "Scrake Emperor";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.4f;
	ZedArch = class'Zed_Arch_ScrakeOmega'.static.GetArch(WorldInfo);
	if (ZedArch != None)
		updateArch();
	super.PostBeginPlay();
}

simulated function updateArch()
{
	ZedArch = class'Zed_Arch_ScrakeOmega'.Static.GetArch(WorldInfo);
	if (ZedArch != None)
	{
		Mesh.SetSkeletalMesh(ZedArch.zedClientArch.CharacterMesh);
		Mesh.AnimSets = ZedArch.zedClientArch.AnimSets;
		Mesh.SetAnimTreeTemplate(ZedArch.zedClientArch.AnimTreeTemplate);
		PawnAnimInfo = ZedArch.zedClientArch.AnimArchetype;
	}
}

defaultproperties
{
	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Scrake_Emperor'

	RageHealthThresholdNormal=0.2f
	RageHealthThresholdHard=0.225f
	RageHealthThresholdSuicidal=0.25f
	RageHealthThresholdHellOnEarth=0.275f

	bLargeZed=True
	bCanRage=True
	DoshValue=400
	XPValues(0)=75
	XPValues(1)=100
	XPValues(2)=135
	XPValues(3)=150
	LocalizationKey="WMPawn_ZedScrake_Emperor"

	Begin Object Class=KFMeleeHelperAI Name=WMMeleeHelper_0
		BaseDamage=20.0f
		MyDamageType=Class'kfgamecontent.KFDT_Slashing_Scrake'
		MomentumTransfer=60000.0f
		MaxHitRange=200.0f
	End Object
	MeleeAttackHelper=WMMeleeHelper_0

	bVersusZed=True

	HitZones(0)=(GoreHealth=3000)
	HitZones(8)=(GoreHealth=75, DmgScale=0.1f)

	SprintSpeed=640.0f

	Mass=225.0f
	GroundSpeed=180.0f
	Health=4000

	Name="Default__WMPawn_ZedScrake_Emperor"
}
