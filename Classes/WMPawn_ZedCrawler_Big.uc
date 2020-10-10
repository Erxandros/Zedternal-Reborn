class WMPawn_ZedCrawler_Big extends WMPawn_ZedCrawler_NoElite;

var float ExtraResistance;

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
	local float currentMod;

	currentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.01f, currentMod - ExtraResistance);
}

defaultproperties
{
	DoshValue=12
	XPValues(0)=12
	XPValues(1)=14
	XPValues(2)=14
	XPValues(3)=15

	bKnockdownWhenJumpedOn=False
	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Crawler_Big'

	Mass=125.0f
	GroundSpeed=485.0f
	SprintSpeed=590.0f
	Health=145
	HitZones(0)=(GoreHealth=125)
	ExtraResistance=0.35f

	Name="Default__WMPawn_ZedCrawler_Big"
}
