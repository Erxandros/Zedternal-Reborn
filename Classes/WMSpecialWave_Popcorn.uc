class WMSpecialWave_Popcorn extends WMSpecialWave;

var float Chance;

static function bool CouldBeZedShrapnel(class<KFDamageType> KFDT )
{
	return true;
}
static function bool ShouldShrapnel()
{
	if (FRand() <= default.Chance)
		return true;
	else
		return false;
}

defaultproperties
{
   Title="Popcorn"
   Description="Make them explode!"
   zedSpawnRateFactor=1.300000
   MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
   MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
   MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
   MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')

   Chance = 0.600000
   
   Name="Default__WMSpecialWave_Popcorn"
}
