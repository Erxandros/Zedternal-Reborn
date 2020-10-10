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
	DoshValue=24
	XPValues(0)=20
	XPValues(1)=24
	XPValues(2)=24
	XPValues(3)=26

	bKnockdownWhenJumpedOn=False
	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Crawler_Big'

	Mass=300.0f
	GroundSpeed=340.0f
	SprintSpeed=420.0f
	Health=375
	HitZones(0)=(GoreHealth=200)
	ExtraResistance=0.55f

	Name="Default__WMPawn_ZedCrawler_Huge"
}
