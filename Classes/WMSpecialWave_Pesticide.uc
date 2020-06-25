class WMSpecialWave_Pesticide extends WMSpecialWave;

defaultproperties
{
	Title="Arachnids"
	Description="Hordes of crawlers are coming!"
	bReplaceMonstertoAdd=true
	zedSpawnRateFactor=2.500000
	waveValueFactor=0.700000
	doshFactor=1.400000
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=6,MaxGr=10,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_Mini')
	MonsterToAdd(1)=(MinWave=0,MaxWave=15,MinGr=4,MaxGr=7,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_Medium')
	MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=7,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_Medium')
	MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=7,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(4)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=7,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(5)=(MinWave=0,MaxWave=20,MinGr=2,MaxGr=4,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_Big')
	MonsterToAdd(6)=(MinWave=3,MaxWave=999,MinGr=2,MaxGr=5,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_Big')
	MonsterToAdd(7)=(MinWave=5,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_Huge')
	MonsterToAdd(8)=(MinWave=7,MaxWave=999,MinGr=1,MaxGr=2,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_Huge')
	MonsterToAdd(9)=(MinWave=10,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_Ultra')
	MonsterToAdd(10)=(MinWave=13,MaxWave=999,MinGr=1,MaxGr=4,MClass=Class'ZedternalReborn.WMPawn_ZedCrawler_Huge')
	Name="Default__WMSpecialWave_Pesticide"
}
