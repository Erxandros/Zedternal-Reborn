class WMPawn_ZedCrawler_Ultra extends WMPawn_ZedCrawler_NoElite;

var float ExtraResistance;

static function string GetLocalizedName()
{
	return "Ultra Crawler";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 2.0f;

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
	DoshValue=48
	XPValues(0)=30
	XPValues(1)=36
	XPValues(2)=36
	XPValues(3)=39

	bKnockdownWhenJumpedOn=False
	DifficultySettings=Class'ZedternalReborn.WMDifficulty_Crawler_Big'

	Mass=450.0f
	GroundSpeed=270.0f
	SprintSpeed=325.0f
	Health=530
	HitZones(0)=(GoreHealth=300)
	ExtraResistance=0.65f

	Name="Default__WMPawn_ZedCrawler_Ultra"
}
