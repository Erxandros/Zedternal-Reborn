class WMPawn_ZedCrawler_Huge extends WMPawn_ZedCrawler_NoElite;

var float ExtraResistance;

static function string GetLocalizedName()
{
	return "Huge Crawler";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.55f;

	super.PostBeginPlay();
}

function float GetDamageTypeModifier(class<DamageType> DT)
{
	local float currentMod;

	currentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.01f, currentMod - ExtraResistance);
}

defaultproperties
{
	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Crawler_Big'

	bKnockdownWhenJumpedOn=False
	DoshValue=24
	Health=375
	Mass=300.0f
	GroundSpeed=340.0f
	SprintSpeed=420.0f
	ExtraResistance=0.55f

	XPValues(0)=16
	XPValues(1)=20
	XPValues(2)=20
	XPValues(3)=20

	HitZones(0)=(GoreHealth=200)

	Name="Default__WMPawn_ZedCrawler_Huge"
}
