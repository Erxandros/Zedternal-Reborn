class WMSpecialWave_Pesticide extends WMSpecialWave;

defaultproperties
{
	ZedSpawnRateFactor=2.5f
	WaveValueFactor=0.75f
	DoshFactor=1.4f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Pesticide"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=5,MaxGr=8,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Mini')
	MonsterToAdd(1)=(MinWave=0,MaxWave=14,MinGr=4,MaxGr=7,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Medium')
	MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=7,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Medium')
	MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=7,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(4)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=7,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(5)=(MinWave=0,MaxWave=16,MinGr=2,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Big')
	MonsterToAdd(6)=(MinWave=3,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Big')
	MonsterToAdd(7)=(MinWave=5,MaxWave=18,MinGr=1,MaxGr=1,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Huge')
	MonsterToAdd(8)=(MinWave=7,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Huge')
	MonsterToAdd(9)=(MinWave=13,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Huge')
	MonsterToAdd(10)=(MinWave=10,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Ultra')
	MonsterToAdd(11)=(MinWave=16,MaxWave=999,MinGr=2,MaxGr=3,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_Ultra')

	Name="Default__WMSpecialWave_Pesticide"
}
