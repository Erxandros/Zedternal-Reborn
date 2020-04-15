class WMPawn_ZedCrawler_Big extends KFPawn_ZedCrawler;

var float ExtraResistance;

static function string GetLocalizedName()
{
	return "Big Crawler";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.2;
	
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
   DoshValue=12
   XPValues(0)=12.000000
   XPValues(1)=14.000000
   XPValues(2)=14.000000
   XPValues(3)=15.000000
   
   bKnockdownWhenJumpedOn=False
   DifficultySettings=Class'Zedternal.WMDifficulty_Crawler_Big'
   
   Mass=125.000000
   GroundSpeed=485.000000
   SprintSpeed=590.000000
   Health=145
   HitZones(0)=(GoreHealth=125)
   ExtraResistance=0.350000
   Name="Default__WMPawn_ZedCrawler_Big"
}
