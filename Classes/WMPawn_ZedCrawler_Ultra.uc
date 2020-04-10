class WMPawn_ZedCrawler_Ultra extends KFPawn_ZedCrawler;

var float ExtraResistance;

static function string GetLocalizedName()
{
	return "Ultra Crawler";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 2;
	
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
   DoshValue=48
   XPValues(0)=30.000000
   XPValues(1)=36.000000
   XPValues(2)=36.000000
   XPValues(3)=39.000000
   
   bKnockdownWhenJumpedOn=False
   DifficultySettings=Class'ZedternalReborn.WMDifficulty_Crawler_Big'
   
   Mass=450.000000
   GroundSpeed=270.000000
   SprintSpeed=325.000000
   Health=530
   HitZones(0)=(GoreHealth=300)
   ExtraResistance=0.650000
   Name="Default__WMPawn_ZedCrawler_Ultra"
}
