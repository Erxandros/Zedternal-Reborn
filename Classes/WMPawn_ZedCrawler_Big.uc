class WMPawn_ZedCrawler_Big extends WMPawn_ZedCrawler_NoElite;

var const float ExtraDamageResistance;

static function string GetLocalizedName()
{
	return "Big Crawler";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.2f;

	super.PostBeginPlay();
}

function float GetDamageTypeModifier(class<DamageType> DT)
{
	local float CurrentMod;

	CurrentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.025f, CurrentMod - ExtraDamageResistance);
}

defaultproperties
{
	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Crawler_Big'

	bKnockdownWhenJumpedOn=False
	DoshValue=12
	Health=145
	Mass=150.0f
	GroundSpeed=485.0f
	SprintSpeed=590.0f
	ExtraDamageResistance=0.35f

	XPValues(0)=12
	XPValues(1)=15
	XPValues(2)=15
	XPValues(3)=15

	HitZones(0)=(GoreHealth=125)

	Name="Default__WMPawn_ZedCrawler_Big"
}
