class WMZedPreload extends Object;

var array< class<KFPawn_Monster> > ZedternalZeds;

defaultproperties
{
	//Base Overrides
	ZedternalZeds(0)=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
	ZedternalZeds(1)=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
	ZedternalZeds(2)=class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
	ZedternalZeds(3)=class'ZedternalReborn.WMPawn_ZedStalker_NoDAR';
	ZedternalZeds(4)=class'ZedternalReborn.WMPawn_ZedHusk_NoDAR';

	//Special Crawlers
	ZedternalZeds(5)=class'ZedternalReborn.WMPawn_ZedCrawler_Mini';
	ZedternalZeds(6)=class'ZedternalReborn.WMPawn_ZedCrawler_Medium';
	ZedternalZeds(7)=class'ZedternalReborn.WMPawn_ZedCrawler_Big';
	ZedternalZeds(8)=class'ZedternalReborn.WMPawn_ZedCrawler_Huge';
	ZedternalZeds(9)=class'ZedternalReborn.WMPawn_ZedCrawler_Ultra';

	//Special Husks
	ZedternalZeds(10)=class'ZedternalReborn.WMPawn_ZedHusk_Tiny_Green';
	ZedternalZeds(11)=class'ZedternalReborn.WMPawn_ZedHusk_Tiny_Blue';
	ZedternalZeds(12)=class'ZedternalReborn.WMPawn_ZedHusk_Tiny_Pink';

	//Special Scrakes
	ZedternalZeds(13)=class'ZedternalReborn.WMPawn_ZedScrake_Tiny';

	//Boss Overrides
	ZedternalZeds(14)=class'ZedternalReborn.WMPawn_ZedFleshpoundKing';
	ZedternalZeds(15)=class'ZedternalReborn.WMPawn_ZedPatriarch';
	ZedternalZeds(16)=class'ZedternalReborn.WMPawn_ZedMatriarch';
	ZedternalZeds(17)=class'ZedternalReborn.WMPawn_ZedHans';
	ZedternalZeds(18)=class'ZedternalReborn.WMPawn_ZedBloatKing';

	//Omega Zeds
	ZedternalZeds(19)=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega';
	ZedternalZeds(20)=class'ZedternalReborn.WMPawn_ZedGorefast_Omega';
	ZedternalZeds(21)=class'ZedternalReborn.WMPawn_ZedStalker_Omega';
	ZedternalZeds(22)=class'ZedternalReborn.WMPawn_ZedHusk_Omega';
	ZedternalZeds(23)=class'ZedternalReborn.WMPawn_ZedSiren_Omega';
	ZedternalZeds(24)=class'ZedternalReborn.WMPawn_ZedScrake_Omega';
	ZedternalZeds(25)=class'ZedternalReborn.WMPawn_ZedFleshpound_Omega';

	//Special Wave Unique Zeds
	ZedternalZeds(26)=class'ZedternalReborn.WMPawn_ZedScrake_Emperor';
	ZedternalZeds(27)=class'ZedternalReborn.WMPawn_ZedFleshpound_Predator';

	Name="Default__WMZedPreload"
}
