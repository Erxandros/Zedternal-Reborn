class WMPawn_ZedCrawler_Huge extends KFPawn_ZedCrawler;

var float ExtraResistance;

static function string GetLocalizedName()
{
	return "Huge Crawler";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.55;
	
	super.PostBeginPlay();
}

/** Returns damage multiplier for an incoming damage type @todo: c++?*/
function float GetDamageTypeModifier(class<DamageType> DT)
{
	local float currentMod;
	
	// Omega ZEDs have extra resistance against all damage type
	currentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.01f, currentMod - ExtraResistance);
}

defaultproperties
{
   DoshValue=24
   XPValues(0)=20.000000
   XPValues(1)=24.000000
   XPValues(2)=24.000000
   XPValues(3)=26.000000
   
   bKnockdownWhenJumpedOn=False
   DifficultySettings=Class'Zedternal.WMDifficulty_Crawler_Big'
   
   Mass=300.000000
   GroundSpeed=340.000000
   SprintSpeed=420.000000
   Health=375
   HitZones(0)=(GoreHealth=200)
   ExtraResistance=0.550000
   Name="Default__WMPawn_ZedCrawler_Huge"
}
