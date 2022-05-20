class WMSpecialWave_Popcorn extends WMSpecialWave;

var float Chance;

static function bool CouldBeZedShrapnel(class<KFDamageType> KFDT)
{
	return True;
}

static function bool ShouldShrapnel()
{
	if (FRand() <= default.Chance)
		return True;
	else
		return False;
}

defaultproperties
{
	Chance=0.6f
	ZedSpawnRateFactor=1.3f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Popcorn"

	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')

	Name="Default__WMSpecialWave_Popcorn"
}
