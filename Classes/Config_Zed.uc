class Config_Zed extends Config_Base
	config(Zedternal);

var config int MODEVERSION;


var config int Zed_MaxDifferentMonster;

struct SZedVariant
{
	var class<KFPawn_Monster> ZedClass;
	var class<KFPawn_Monster> VariantClass;
	var float probability;
	var int minDifficulty;
	var int maxDifficulty;
};
var config array< SZedVariant > Zed_ZedVariant;

struct SMonster
{
	var int MinWave, MaxWave;
	var int MinGr, MaxGr;
	var class<KFPawn_Monster> MClass;
};
var config array<SMonster> Zed_Monsters;

struct SMonsterValue
{
	var class<KFPawn_Monster> ZedClass;
	var int Value;
	var int ValuePerExtraPlayer;
	
	structdefaultproperties
	{
		ValuePerExtraPlayer=0;
	}
};
var config array< SMonsterValue > Zed_Value;

	
static function UpdateConfig()
{
	local int i;
	local SMonster tempMonster;
	local SMonsterValue tempValue;
	local SZedVariant tempVariant;
	
	if (default.MODEVERSION < 2)
	{
		
		default.Zed_MaxDifferentMonster=10;
		
		/////////////////////////////
		///////// ZED List //////////
		/////////////////////////////
		
		default.Zed_Monsters.length = 60;
		
		// Clots
		
		default.Zed_Monsters[0].MClass=Class'KFGameContent.KFPawn_ZedClot_Cyst';
		default.Zed_Monsters[0].MinWave=0;
		default.Zed_Monsters[0].MaxWave=2;
		default.Zed_Monsters[0].MinGr=2;
		default.Zed_Monsters[0].MaxGr=4;
		
		default.Zed_Monsters[1].MClass=Class'KFGameContent.KFPawn_ZedClot_Cyst';		
		default.Zed_Monsters[1].MinWave=0;
		default.Zed_Monsters[1].MaxWave=7;
		default.Zed_Monsters[1].MinGr=2;
		default.Zed_Monsters[1].MaxGr=6;
		
		default.Zed_Monsters[2].MClass=Class'KFGameContent.KFPawn_ZedClot_Alpha';
		default.Zed_Monsters[2].MinWave=0;
		default.Zed_Monsters[2].MaxWave=4;
		default.Zed_Monsters[2].MinGr=1;
		default.Zed_Monsters[2].MaxGr=4;
	
		default.Zed_Monsters[3].MClass=Class'KFGameContent.KFPawn_ZedClot_Alpha';
		default.Zed_Monsters[3].MinWave=0;
		default.Zed_Monsters[3].MaxWave=999;
		default.Zed_Monsters[3].MinGr=2;
		default.Zed_Monsters[3].MaxGr=6;
		
		default.Zed_Monsters[4].MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher';		
		default.Zed_Monsters[4].MinWave=0;
		default.Zed_Monsters[4].MaxWave=2;
		default.Zed_Monsters[4].MinGr=1;
		default.Zed_Monsters[4].MaxGr=1;
		
		default.Zed_Monsters[5].MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher';
		default.Zed_Monsters[5].MinWave=0;
		default.Zed_Monsters[5].MaxWave=8;
		default.Zed_Monsters[5].MinGr=1;
		default.Zed_Monsters[5].MaxGr=3;
		
		default.Zed_Monsters[6].MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher';
		default.Zed_Monsters[6].MinWave=0;
		default.Zed_Monsters[6].MaxWave=15;
		default.Zed_Monsters[6].MinGr=1;
		default.Zed_Monsters[6].MaxGr=4;
		
		default.Zed_Monsters[7].MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher';
		default.Zed_Monsters[7].MinWave=2;
		default.Zed_Monsters[7].MaxWave=999;
		default.Zed_Monsters[7].MinGr=2;
		default.Zed_Monsters[7].MaxGr=6;
		
		// Crawler
		
		default.Zed_Monsters[8].MClass=Class'KFGameContent.KFPawn_ZedCrawler';
		default.Zed_Monsters[8].MinWave=0;
		default.Zed_Monsters[8].MaxWave=999;
		default.Zed_Monsters[8].MinGr=1;
		default.Zed_Monsters[8].MaxGr=4;
		
		default.Zed_Monsters[9].MClass=Class'KFGameContent.KFPawn_ZedCrawler';
		default.Zed_Monsters[9].MinWave=5;
		default.Zed_Monsters[9].MaxWave=999;
		default.Zed_Monsters[9].MinGr=2;
		default.Zed_Monsters[9].MaxGr=7;
		
		// Stalker
		
		default.Zed_Monsters[10].MClass=Class'KFGameContent.KFPawn_ZedStalker';
		default.Zed_Monsters[10].MinWave=3;
		default.Zed_Monsters[10].MaxWave=5;
		default.Zed_Monsters[10].MinGr=1;
		default.Zed_Monsters[10].MaxGr=4;
		
		default.Zed_Monsters[11].MClass=Class'KFGameContent.KFPawn_ZedStalker';
		default.Zed_Monsters[11].MinWave=5;
		default.Zed_Monsters[11].MaxWave=999;
		default.Zed_Monsters[11].MinGr=2;
		default.Zed_Monsters[11].MaxGr=5;
		
		default.Zed_Monsters[12].MClass=Class'Zedternal.WMPawn_ZedStalker_Omega';
		default.Zed_Monsters[12].MinWave=14;
		default.Zed_Monsters[12].MaxWave=999;
		default.Zed_Monsters[12].MinGr=3;
		default.Zed_Monsters[12].MaxGr=6;
		
		// Gorefast
		
		default.Zed_Monsters[13].MClass=Class'KFGameContent.KFPawn_ZedGorefast';
		default.Zed_Monsters[13].MinWave=0;
		default.Zed_Monsters[13].MaxWave=3;
		default.Zed_Monsters[13].MinGr=1;
		default.Zed_Monsters[13].MaxGr=2;
		
		default.Zed_Monsters[14].MClass=Class'KFGameContent.KFPawn_ZedGorefast';
		default.Zed_Monsters[14].MinWave=2;
		default.Zed_Monsters[14].MaxWave=999;
		default.Zed_Monsters[14].MinGr=1;
		default.Zed_Monsters[14].MaxGr=4;
		
		default.Zed_Monsters[15].MClass=Class'KFGameContent.KFPawn_ZedGorefast';
		default.Zed_Monsters[15].MinWave=5;
		default.Zed_Monsters[15].MaxWave=999;
		default.Zed_Monsters[15].MinGr=3;
		default.Zed_Monsters[15].MaxGr=6;
		
		default.Zed_Monsters[16].MClass=Class'Zedternal.WMPawn_ZedGorefast_Omega';
		default.Zed_Monsters[16].MinWave=11;
		default.Zed_Monsters[16].MaxWave=16;
		default.Zed_Monsters[16].MinGr=1;
		default.Zed_Monsters[16].MaxGr=1;
		
		default.Zed_Monsters[17].MClass=Class'Zedternal.WMPawn_ZedGorefast_Omega';
		default.Zed_Monsters[17].MinWave=16;
		default.Zed_Monsters[17].MaxWave=999;
		default.Zed_Monsters[17].MinGr=2;
		default.Zed_Monsters[17].MaxGr=4;
		
		default.Zed_Monsters[18].MClass=Class'Zedternal.WMPawn_ZedGorefast_Omega';
		default.Zed_Monsters[18].MinWave=21;
		default.Zed_Monsters[18].MaxWave=999;
		default.Zed_Monsters[18].MinGr=4;
		default.Zed_Monsters[18].MaxGr=8;
		
		// Bloat
		
		default.Zed_Monsters[19].MClass=Class'KFGameContent.KFPawn_ZedBloat';
		default.Zed_Monsters[19].MinWave=2;
		default.Zed_Monsters[19].MaxWave=4;
		default.Zed_Monsters[19].MinGr=1;
		default.Zed_Monsters[19].MaxGr=1;
		
		default.Zed_Monsters[20].MClass=Class'KFGameContent.KFPawn_ZedBloat';
		default.Zed_Monsters[20].MinWave=5;
		default.Zed_Monsters[20].MaxWave=999;
		default.Zed_Monsters[20].MinGr=1;
		default.Zed_Monsters[20].MaxGr=2;
		
		default.Zed_Monsters[21].MClass=Class'KFGameContent.KFPawn_ZedBloat';
		default.Zed_Monsters[21].MinWave=11;
		default.Zed_Monsters[21].MaxWave=999;
		default.Zed_Monsters[21].MinGr=1;
		default.Zed_Monsters[21].MaxGr=4;
		
		// Husk
		
		default.Zed_Monsters[22].MClass=Class'KFGameContent.KFPawn_ZedHusk';
		default.Zed_Monsters[22].MinWave=3;
		default.Zed_Monsters[22].MaxWave=5;
		default.Zed_Monsters[22].MinGr=1;
		default.Zed_Monsters[22].MaxGr=1;
		
		default.Zed_Monsters[23].MClass=Class'KFGameContent.KFPawn_ZedHusk';
		default.Zed_Monsters[23].MinWave=6;
		default.Zed_Monsters[23].MaxWave=999;
		default.Zed_Monsters[23].MinGr=1;
		default.Zed_Monsters[23].MaxGr=2;
		
		default.Zed_Monsters[24].MClass=Class'KFGameContent.KFPawn_ZedHusk';
		default.Zed_Monsters[24].MinWave=11;
		default.Zed_Monsters[24].MaxWave=999;
		default.Zed_Monsters[24].MinGr=1;
		default.Zed_Monsters[24].MaxGr=3;
		
		default.Zed_Monsters[25].MClass=Class'Zedternal.WMPawn_ZedHusk_Omega';
		default.Zed_Monsters[25].MinWave=16;
		default.Zed_Monsters[25].MaxWave=999;
		default.Zed_Monsters[25].MinGr=1;
		default.Zed_Monsters[25].MaxGr=2;
		
		default.Zed_Monsters[26].MClass=Class'Zedternal.WMPawn_ZedHusk_Omega';
		default.Zed_Monsters[26].MinWave=21;
		default.Zed_Monsters[26].MaxWave=999;
		default.Zed_Monsters[26].MinGr=1;
		default.Zed_Monsters[26].MaxGr=5;
		
		// Siren
		
		default.Zed_Monsters[27].MClass=Class'KFGameContent.KFPawn_ZedSiren';
		default.Zed_Monsters[27].MinWave=4;
		default.Zed_Monsters[27].MaxWave=999;
		default.Zed_Monsters[27].MinGr=1;
		default.Zed_Monsters[27].MaxGr=1;
		
		default.Zed_Monsters[28].MClass=Class'KFGameContent.KFPawn_ZedSiren';
		default.Zed_Monsters[28].MinWave=9;
		default.Zed_Monsters[28].MaxWave=999;
		default.Zed_Monsters[28].MinGr=1;
		default.Zed_Monsters[28].MaxGr=2;
		
		default.Zed_Monsters[29].MClass=Class'Zedternal.WMPawn_ZedSiren_Omega';
		default.Zed_Monsters[29].MinWave=16;
		default.Zed_Monsters[29].MaxWave=999;
		default.Zed_Monsters[29].MinGr=3;
		default.Zed_Monsters[29].MaxGr=4;
		
		// Fleshpound Mini
		
		default.Zed_Monsters[30].MClass=Class'KFGameContent.KFPawn_ZedFleshpoundMini';
		default.Zed_Monsters[30].MinWave=5;
		default.Zed_Monsters[30].MaxWave=10;
		default.Zed_Monsters[30].MinGr=1;
		default.Zed_Monsters[30].MaxGr=1;
		
		default.Zed_Monsters[31].MClass=Class'KFGameContent.KFPawn_ZedFleshpoundMini';
		default.Zed_Monsters[31].MinWave=11;
		default.Zed_Monsters[31].MaxWave=15;
		default.Zed_Monsters[31].MinGr=1;
		default.Zed_Monsters[31].MaxGr=3;
		
		// Scrake
		
		default.Zed_Monsters[32].MClass=Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_Monsters[32].MinWave=3;
		default.Zed_Monsters[32].MaxWave=5;
		default.Zed_Monsters[32].MinGr=1;
		default.Zed_Monsters[32].MaxGr=1;
		
		default.Zed_Monsters[33].MClass=Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_Monsters[33].MinWave=6;
		default.Zed_Monsters[33].MaxWave=999;
		default.Zed_Monsters[33].MinGr=1;
		default.Zed_Monsters[33].MaxGr=2;
		
		default.Zed_Monsters[34].MClass=Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_Monsters[34].MinWave=10;
		default.Zed_Monsters[34].MaxWave=15;
		default.Zed_Monsters[34].MinGr=1;
		default.Zed_Monsters[34].MaxGr=3;
		
		default.Zed_Monsters[35].MClass=Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_Monsters[35].MinWave=16;
		default.Zed_Monsters[35].MaxWave=999;
		default.Zed_Monsters[35].MinGr=1;
		default.Zed_Monsters[35].MaxGr=4;
		
		default.Zed_Monsters[36].MClass=Class'Zedternal.WMPawn_ZedScrake_Omega';
		default.Zed_Monsters[36].MinWave=16;
		default.Zed_Monsters[36].MaxWave=30;
		default.Zed_Monsters[36].MinGr=1;
		default.Zed_Monsters[36].MaxGr=1;
		
		default.Zed_Monsters[37].MClass=Class'Zedternal.WMPawn_ZedScrake_Omega';
		default.Zed_Monsters[37].MinWave=21;
		default.Zed_Monsters[37].MaxWave=999;
		default.Zed_Monsters[37].MinGr=1;
		default.Zed_Monsters[37].MaxGr=2;
		
		default.Zed_Monsters[38].MClass=Class'Zedternal.WMPawn_ZedScrake_Omega';
		default.Zed_Monsters[38].MinWave=26;
		default.Zed_Monsters[38].MaxWave=999;
		default.Zed_Monsters[38].MinGr=1;
		default.Zed_Monsters[38].MaxGr=4;
		
		default.Zed_Monsters[39].MClass=Class'Zedternal.WMPawn_ZedScrake_Omega';
		default.Zed_Monsters[39].MinWave=31;
		default.Zed_Monsters[39].MaxWave=999;
		default.Zed_Monsters[39].MinGr=2;
		default.Zed_Monsters[39].MaxGr=6;
		
		// Fleshpound
		
		default.Zed_Monsters[40].MClass=Class'KFGameContent.KFPawn_ZedFleshpound';
		default.Zed_Monsters[40].MinWave=6;
		default.Zed_Monsters[40].MaxWave=999;
		default.Zed_Monsters[40].MinGr=1;
		default.Zed_Monsters[40].MaxGr=1;
		
		default.Zed_Monsters[41].MClass=Class'KFGameContent.KFPawn_ZedFleshpound';
		default.Zed_Monsters[41].MinWave=10;
		default.Zed_Monsters[41].MaxWave=999;
		default.Zed_Monsters[41].MinGr=1;
		default.Zed_Monsters[41].MaxGr=2;
		
		default.Zed_Monsters[42].MClass=Class'Zedternal.WMPawn_ZedFleshpound_Omega';
		default.Zed_Monsters[42].MinWave=21;
		default.Zed_Monsters[42].MaxWave=27;
		default.Zed_Monsters[42].MinGr=1;
		default.Zed_Monsters[42].MaxGr=1;
		
		default.Zed_Monsters[43].MClass=Class'Zedternal.WMPawn_ZedFleshpound_Omega';
		default.Zed_Monsters[43].MinWave=24;
		default.Zed_Monsters[43].MaxWave=999;
		default.Zed_Monsters[43].MinGr=1;
		default.Zed_Monsters[43].MaxGr=2;
		
		default.Zed_Monsters[44].MClass=Class'Zedternal.WMPawn_ZedFleshpound_Omega';
		default.Zed_Monsters[44].MinWave=28;
		default.Zed_Monsters[44].MaxWave=999;
		default.Zed_Monsters[44].MinGr=2;
		default.Zed_Monsters[44].MaxGr=3;
		
		// Fleshpound King / Bloat King
		
		default.Zed_Monsters[45].MClass=Class'Zedternal.WMPawn_ZedFleshpoundKing';
		default.Zed_Monsters[45].MinWave=14;
		default.Zed_Monsters[45].MaxWave=999;
		default.Zed_Monsters[45].MinGr=1;
		default.Zed_Monsters[45].MaxGr=1;
		
		default.Zed_Monsters[46].MClass=Class'Zedternal.WMPawn_ZedFleshpoundKing';
		default.Zed_Monsters[46].MinWave=21;
		default.Zed_Monsters[46].MaxWave=999;
		default.Zed_Monsters[46].MinGr=1;
		default.Zed_Monsters[46].MaxGr=1;
		
		default.Zed_Monsters[47].MClass=Class'Zedternal.WMPawn_ZedFleshpoundKing';
		default.Zed_Monsters[47].MinWave=26;
		default.Zed_Monsters[47].MaxWave=999;
		default.Zed_Monsters[47].MinGr=1;
		default.Zed_Monsters[47].MaxGr=2;
		
		default.Zed_Monsters[48].MClass=Class'Zedternal.WMPawn_ZedFleshpoundKing';
		default.Zed_Monsters[48].MinWave=31;
		default.Zed_Monsters[48].MaxWave=999;
		default.Zed_Monsters[48].MinGr=1;
		default.Zed_Monsters[48].MaxGr=3;
		
		// Patriarch / Hans
		
		default.Zed_Monsters[49].MClass=Class'Zedternal.WMPawn_ZedPatriarch';
		default.Zed_Monsters[49].MinWave=16;
		default.Zed_Monsters[49].MaxWave=999;
		default.Zed_Monsters[49].MinGr=1;
		default.Zed_Monsters[49].MaxGr=1;
		
		default.Zed_Monsters[50].MClass=Class'Zedternal.WMPawn_ZedPatriarch';
		default.Zed_Monsters[50].MinWave=21;
		default.Zed_Monsters[50].MaxWave=999;
		default.Zed_Monsters[50].MinGr=1;
		default.Zed_Monsters[50].MaxGr=1;
		
		default.Zed_Monsters[51].MClass=Class'Zedternal.WMPawn_ZedPatriarch';
		default.Zed_Monsters[51].MinWave=26;
		default.Zed_Monsters[51].MaxWave=999;
		default.Zed_Monsters[51].MinGr=1;
		default.Zed_Monsters[51].MaxGr=2;
		
		default.Zed_Monsters[52].MClass=Class'Zedternal.WMPawn_ZedPatriarch';
		default.Zed_Monsters[52].MinWave=31;
		default.Zed_Monsters[52].MaxWave=999;
		default.Zed_Monsters[52].MinGr=1;
		default.Zed_Monsters[52].MaxGr=3;
		
		default.Zed_Monsters[53].MClass=Class'Zedternal.WMPawn_ZedPatriarch';
		default.Zed_Monsters[53].MinWave=36;
		default.Zed_Monsters[53].MaxWave=999;
		default.Zed_Monsters[53].MinGr=2;
		default.Zed_Monsters[53].MaxGr=3;
		
		default.Zed_Monsters[54].MClass=Class'Zedternal.WMPawn_ZedFleshpoundKing';
		default.Zed_Monsters[54].MinWave=41;
		default.Zed_Monsters[54].MaxWave=999;
		default.Zed_Monsters[54].MinGr=3;
		default.Zed_Monsters[54].MaxGr=5;
		
		default.Zed_Monsters[55].MClass=Class'Zedternal.WMPawn_ZedPatriarch';
		default.Zed_Monsters[55].MinWave=46;
		default.Zed_Monsters[55].MaxWave=999;
		default.Zed_Monsters[55].MinGr=4;
		default.Zed_Monsters[55].MaxGr=5;

		default.Zed_Monsters[56].MClass=Class'KFGameContent.KFPawn_ZedDAR_Rocket';
		default.Zed_Monsters[56].MinWave=11;
		default.Zed_Monsters[56].MaxWave=999;
		default.Zed_Monsters[56].MinGr=1;
		default.Zed_Monsters[56].MaxGr=1;
		
		default.Zed_Monsters[57].MClass=Class'KFGameContent.KFPawn_ZedBloatKingSubspawn';
		default.Zed_Monsters[57].MinWave=15;
		default.Zed_Monsters[57].MaxWave=999;
		default.Zed_Monsters[57].MinGr=1;
		default.Zed_Monsters[57].MaxGr=2;
		
		default.Zed_Monsters[58].MClass=Class'Zedternal.WMPawn_ZedCrawler_Huge';
		default.Zed_Monsters[58].MinWave=20;
		default.Zed_Monsters[58].MaxWave=999;
		default.Zed_Monsters[58].MinGr=1;
		default.Zed_Monsters[58].MaxGr=1;
		
		default.Zed_Monsters[59].MClass=Class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		default.Zed_Monsters[59].MinWave=21;
		default.Zed_Monsters[59].MaxWave=999;
		default.Zed_Monsters[59].MinGr=1;
		default.Zed_Monsters[59].MaxGr=4;
		
		/////////////////////////////
		/////// ZEDs Values /////////
		/////////////////////////////
		
		default.Zed_Value.length = 36;
		
		default.Zed_Value[0].ZedClass = Class'KFGameContent.KFPawn_ZedClot_Cyst';
		default.Zed_Value[0].Value = 6;
		
		default.Zed_Value[1].ZedClass = Class'KFGameContent.KFPawn_ZedClot_Alpha';
		default.Zed_Value[1].Value = 6;
		
		default.Zed_Value[2].ZedClass = Class'KFGameContent.KFPawn_ZedClot_Slasher';
		default.Zed_Value[2].Value = 7;
		
		default.Zed_Value[3].ZedClass = Class'KFGameContent.KFPawn_ZedCrawler';
		default.Zed_Value[3].Value = 8;

		
		default.Zed_Value[4].ZedClass = Class'KFGameContent.KFPawn_ZedStalker';
		default.Zed_Value[4].Value = 10;
		
		default.Zed_Value[5].ZedClass = Class'Zedternal.WMPawn_ZedStalker_Omega';
		default.Zed_Value[5].Value = 25;
		
		default.Zed_Value[6].ZedClass = Class'KFGameContent.KFPawn_ZedGorefast';
		default.Zed_Value[6].Value = 16;
		
		default.Zed_Value[7].ZedClass = Class'Zedternal.WMPawn_ZedGorefast_Omega';
		default.Zed_Value[7].Value = 40;
		
		default.Zed_Value[8].ZedClass = Class'KFGameContent.KFPawn_ZedBloat';
		default.Zed_Value[8].Value = 25;
		
		default.Zed_Value[9].ZedClass = Class'KFGameContent.KFPawn_ZedHusk';
		default.Zed_Value[9].Value = 25;
		
		default.Zed_Value[10].ZedClass = Class'Zedternal.WMPawn_ZedHusk_Omega';
		default.Zed_Value[10].Value = 70;
		
		default.Zed_Value[11].ZedClass = Class'KFGameContent.KFPawn_ZedSiren';
		default.Zed_Value[11].Value = 30;
		
		default.Zed_Value[12].ZedClass = Class'Zedternal.WMPawn_ZedSiren_Omega';
		default.Zed_Value[12].Value = 45;
		
		default.Zed_Value[13].ZedClass = Class'KFGameContent.KFPawn_ZedFleshpoundMini';
		default.Zed_Value[13].Value = 100;
		default.Zed_Value[13].ValuePerExtraPlayer = 8;
		
		default.Zed_Value[14].ZedClass = Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_Value[14].Value = 110;
		default.Zed_Value[14].ValuePerExtraPlayer = 9;
		
		default.Zed_Value[15].ZedClass = Class'Zedternal.WMPawn_ZedScrake_Omega';
		default.Zed_Value[15].Value = 400;
		default.Zed_Value[15].ValuePerExtraPlayer = 32;
		
		default.Zed_Value[16].ZedClass = Class'KFGameContent.KFPawn_ZedFleshpound';
		default.Zed_Value[16].Value = 175;
		default.Zed_Value[16].ValuePerExtraPlayer = 14;
		
		default.Zed_Value[17].ZedClass = Class'Zedternal.WMPawn_ZedFleshpound_Omega';
		default.Zed_Value[17].Value = 400;
		default.Zed_Value[17].ValuePerExtraPlayer = 32;
		
		default.Zed_Value[18].ZedClass = Class'Zedternal.WMPawn_ZedFleshpoundKing';
		default.Zed_Value[18].Value = 900;
		default.Zed_Value[18].ValuePerExtraPlayer = 72;
		
		default.Zed_Value[19].ZedClass = Class'Zedternal.WMPawn_ZedPatriarch';
		default.Zed_Value[19].Value = 1100;
		default.Zed_Value[19].ValuePerExtraPlayer = 88;
		
		default.Zed_Value[20].ZedClass = Class'Zedternal.WMPawn_ZedHans';
		default.Zed_Value[20].Value = 1100;
		default.Zed_Value[20].ValuePerExtraPlayer = 88;
		
		default.Zed_Value[21].ZedClass = Class'KFGameContent.KFPawn_ZedCrawlerKing';
		default.Zed_Value[21].Value = 20;
		
		default.Zed_Value[22].ZedClass = Class'Zedternal.WMPawn_ZedScrake_Tiny';
		default.Zed_Value[22].Value = 80;
		
		default.Zed_Value[23].ZedClass = Class'KFGameContent.KFPawn_ZedDAR_Rocket';
		default.Zed_Value[23].Value = 45;
		
		default.Zed_Value[24].ZedClass = Class'KFGameContent.KFPawn_ZedDAR_Laser';
		default.Zed_Value[24].Value = 45;
		
		default.Zed_Value[25].ZedClass = Class'KFGameContent.KFPawn_ZedDAR_EMP';
		default.Zed_Value[25].Value = 45;
		
		default.Zed_Value[26].ZedClass = Class'Zedternal.WMPawn_ZedCrawler_Mini';
		default.Zed_Value[26].Value = 5;
		
		default.Zed_Value[27].ZedClass = Class'Zedternal.WMPawn_ZedCrawler_Medium';
		default.Zed_Value[27].Value = 7;
		
		default.Zed_Value[28].ZedClass = Class'Zedternal.WMPawn_ZedCrawler_Big';
		default.Zed_Value[28].Value = 20;
		
		default.Zed_Value[29].ZedClass = Class'Zedternal.WMPawn_ZedCrawler_Huge';
		default.Zed_Value[29].Value = 45;
		
		default.Zed_Value[30].ZedClass = Class'Zedternal.WMPawn_ZedCrawler_Ultra';
		default.Zed_Value[30].Value = 75;
		
		default.Zed_Value[31].ZedClass = Class'KFGameContent.KFPawn_ZedGorefastDualBlade';
		default.Zed_Value[31].Value = 35;
		
		default.Zed_Value[32].ZedClass = Class'Zedternal.WMPawn_ZedHusk_NoDAR';
		default.Zed_Value[32].Value = 25;
		
		default.Zed_Value[33].ZedClass = Class'Zedternal.WMPawn_ZedBloatKing';
		default.Zed_Value[33].Value = 900;
		default.Zed_Value[33].ValuePerExtraPlayer = 72;
		
		default.Zed_Value[34].ZedClass = Class'KFGameContent.KFPawn_ZedBloatKingSubspawn';
		default.Zed_Value[34].Value = 15;
		
		default.Zed_Value[35].ZedClass = Class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		default.Zed_Value[35].Value = 20;
		
		
		/////////////////////////////
		/////// Variant List ////////
		/////////////////////////////
		
		default.Zed_ZedVariant.length = 8;
		
		default.Zed_ZedVariant[0].ZedClass=Class'KFGameContent.KFPawn_ZedCrawler';
		default.Zed_ZedVariant[0].VariantClass=Class'KFGameContent.KFPawn_ZedCrawlerKing';
		default.Zed_ZedVariant[0].probability=0.040000;
		default.Zed_ZedVariant[0].minDifficulty=0;
		default.Zed_ZedVariant[0].maxDifficulty=4;
		
		default.Zed_ZedVariant[1].ZedClass=Class'Zedternal.WMPawn_ZedPatriarch';
		default.Zed_ZedVariant[1].VariantClass=Class'Zedternal.WMPawn_ZedHans';
		default.Zed_ZedVariant[1].probability=0.500000;
		default.Zed_ZedVariant[1].minDifficulty=0;
		default.Zed_ZedVariant[1].maxDifficulty=4;
				
		default.Zed_ZedVariant[2].ZedClass=Class'Zedternal.WMPawn_ZedFleshpoundKing';
		default.Zed_ZedVariant[2].VariantClass=Class'Zedternal.WMPawn_ZedBloatKing';
		default.Zed_ZedVariant[2].probability=0.500000;
		default.Zed_ZedVariant[2].minDifficulty=0;
		default.Zed_ZedVariant[2].maxDifficulty=4;
		
		default.Zed_ZedVariant[3].ZedClass=Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_ZedVariant[3].VariantClass=Class'Zedternal.WMPawn_ZedScrake_Tiny';
		default.Zed_ZedVariant[3].probability=0.010000;
		default.Zed_ZedVariant[3].minDifficulty=0;
		default.Zed_ZedVariant[3].maxDifficulty=4;
		
		default.Zed_ZedVariant[4].ZedClass=Class'KFGameContent.KFPawn_ZedHusk';
		default.Zed_ZedVariant[4].VariantClass=Class'Zedternal.WMPawn_ZedHusk_NoDAR';
		default.Zed_ZedVariant[4].probability=1.000000;
		default.Zed_ZedVariant[4].minDifficulty=0;
		default.Zed_ZedVariant[4].maxDifficulty=4;
				
		default.Zed_ZedVariant[5].ZedClass=Class'KFGameContent.KFPawn_ZedStalker';
		default.Zed_ZedVariant[5].VariantClass=Class'Zedternal.WMPawn_ZedStalker_NoDAR';
		default.Zed_ZedVariant[5].probability=1.000000;
		default.Zed_ZedVariant[5].minDifficulty=0;
		default.Zed_ZedVariant[5].maxDifficulty=4;
		
		default.Zed_ZedVariant[6].ZedClass=Class'KFGameContent.KFPawn_ZedDAR_Rocket';
		default.Zed_ZedVariant[6].VariantClass=Class'KFGameContent.KFPawn_ZedDAR_EMP';
		default.Zed_ZedVariant[6].probability=0.333333;
		default.Zed_ZedVariant[6].minDifficulty=0;
		default.Zed_ZedVariant[6].maxDifficulty=4;
		
		default.Zed_ZedVariant[7].ZedClass=Class'KFGameContent.KFPawn_ZedDAR_Rocket';
		default.Zed_ZedVariant[7].VariantClass=Class'KFGameContent.KFPawn_ZedDAR_Laser';
		default.Zed_ZedVariant[7].probability=0.333333;
		default.Zed_ZedVariant[7].minDifficulty=0;
		default.Zed_ZedVariant[7].maxDifficulty=4;
		
	}
	
	if (default.MODEVERSION < 3)
	{
		// reduce number of Abomination's minions
		if (default.Zed_Monsters[57].MClass == Class'KFGameContent.KFPawn_ZedBloatKingSubspawn' && default.Zed_Monsters[57].MaxGr == 2)
		{
			default.Zed_Monsters[57].MaxGr = 1;
		}
	}
	
	if (default.MODEVERSION < 4)
	{
		// zeds spawn sooner in the game
		for (i=0; i<default.Zed_Monsters.length; i+=1)
		{
			default.Zed_Monsters[i].MinWave = Round(default.Zed_Monsters[i].MinWave * 0.8);
		}
	}
	
	if (default.MODEVERSION < 5)
	{
		if (default.Zed_Monsters[31].MClass == Class'KFGameContent.KFPawn_ZedFleshpoundMini' && default.Zed_Monsters[31].MaxGr == 3)
			default.Zed_Monsters[31].MaxGr = 1;
	}
	
	if (default.MODEVERSION < 6)
	{
		// rework on bosses (they are now similar to the vanilla game).
		// first, remove current bosses from the config file
		for (i=0; i<default.Zed_Monsters.length; i+=1)
		{
			if (default.Zed_Monsters[i].MClass==Class'Zedternal.WMPawn_ZedFleshpoundKing' || default.Zed_Monsters[i].MClass==Class'Zedternal.WMPawn_ZedPatriarch')
			{
				default.Zed_Monsters.Remove(i, 1);
				i -= 1;
			}
		}
		
		// then, add new bosses config
		tempMonster.MClass =Class'Zedternal.WMPawn_ZedFleshpoundKing';
		tempMonster.MinGr = 1;
		tempMonster.MaxGr = 1;
		tempMonster.MinWave = 17;
		tempMonster.MaxWave = 999;
		default.Zed_Monsters.AddItem(tempMonster);
		
		tempMonster.MClass =Class'Zedternal.WMPawn_ZedPatriarch';
		tempMonster.MinWave = 21;
		tempMonster.MaxWave = 999;
		default.Zed_Monsters.AddItem(tempMonster);
		
		tempMonster.MClass =Class'Zedternal.WMPawn_ZedFleshpoundKing';
		tempMonster.MinWave = 25;
		tempMonster.MaxWave = 999;
		default.Zed_Monsters.AddItem(tempMonster);
		
		tempMonster.MClass =Class'Zedternal.WMPawn_ZedPatriarch';
		tempMonster.MinWave = 29;
		tempMonster.MaxWave = 999;
		default.Zed_Monsters.AddItem(tempMonster);
		
		// also, change there values
		for (i=0; i<default.Zed_Value.length; i+=1)
		{
			if (default.Zed_Value[i].ZedClass==Class'Zedternal.WMPawn_ZedFleshpoundKing' || default.Zed_Value[i].ZedClass==Class'Zedternal.WMPawn_ZedPatriarch' || default.Zed_Value[i].ZedClass==Class'Zedternal.WMPawn_ZedBloatKing' || default.Zed_Value[i].ZedClass==Class'Zedternal.WMPawn_ZedHans')
			{
				default.Zed_Value[i].Value = 2000;
				default.Zed_Value[i].ValuePerExtraPlayer = 160;
			}
		}

	}
	
	if (default.MODEVERSION < 7)
	{
		// increase by 1 number of different zeds
		if (default.Zed_MaxDifferentMonster == 10)
			default.Zed_MaxDifferentMonster = 11;
		
		// remove omega sirens
		for (i=0; i<default.Zed_Monsters.length; i+=1)
		{
			if (default.Zed_Monsters[i].MClass==Class'Zedternal.WMPawn_ZedSiren_Omega')
			{
				default.Zed_Monsters.Remove(i, 1);
				i -= 1;
			}
		}
		
		// add new omega slasher
		tempMonster.MClass = Class'Zedternal.WMPawn_ZedClot_Slasher_Omega';
		tempMonster.MinGr = 1;
		tempMonster.MaxGr = 4;
		tempMonster.MinWave = 9;
		tempMonster.MaxWave = 999;
		default.Zed_Monsters.AddItem(tempMonster);
		
		tempMonster.MinGr = 2;
		tempMonster.MaxGr = 4;
		tempMonster.MinWave = 17;
		tempMonster.MaxWave = 999;
		default.Zed_Monsters.AddItem(tempMonster);
		
		tempValue.ZedClass = Class'Zedternal.WMPawn_ZedClot_Slasher_Omega';
		tempValue.Value = 24;
		tempValue.ValuePerExtraPlayer = 0;
		default.Zed_Value.AddItem(tempValue);
	}
	
	if (default.MODEVERSION < 9)
	{
		// change boss values
		for (i=0; i<default.Zed_Value.length; i+=1)
		{
			if (default.Zed_Value[i].Value == 2000)
			{
				if (default.Zed_Value[i].ZedClass==Class'Zedternal.WMPawn_ZedFleshpoundKing' || default.Zed_Value[i].ZedClass==Class'Zedternal.WMPawn_ZedPatriarch' || default.Zed_Value[i].ZedClass==Class'Zedternal.WMPawn_ZedBloatKing' || default.Zed_Value[i].ZedClass==Class'Zedternal.WMPawn_ZedHans')
				{
					default.Zed_Value[i].Value = 2400;
					default.Zed_Value[i].ValuePerExtraPlayer = 200;
				}
			}
		}
		
		// exchange FleshpoundKing by Patriarch
		for (i=0; i<default.Zed_Monsters.length; i+=1)
		{
			if (default.Zed_Monsters[i].MClass==Class'Zedternal.WMPawn_ZedFleshpoundKing' && default.Zed_Monsters[i].MinWave == 17)
				default.Zed_Monsters[i].MClass = Class'Zedternal.WMPawn_ZedPatriarch';
			else if (default.Zed_Monsters[i].MClass==Class'Zedternal.WMPawn_ZedPatriarch' && default.Zed_Monsters[i].MinWave == 21)
				default.Zed_Monsters[i].MClass = Class'Zedternal.WMPawn_ZedFleshpoundKing';
		}
		
		// add more basic enemies
		tempMonster.MClass = Class'kfgamecontent.KFPawn_ZedClot_Cyst';
		tempMonster.MinGr = 1;
		tempMonster.MaxGr = 4;
		tempMonster.MinWave = 0;
		tempMonster.MaxWave = 16;
		default.Zed_Monsters.AddItem(tempMonster);
		
		tempMonster.MClass = Class'kfgamecontent.KFPawn_ZedClot_Alpha';
		tempMonster.MinGr = 1;
		tempMonster.MaxGr = 4;
		tempMonster.MinWave = 0;
		tempMonster.MaxWave = 20;
		default.Zed_Monsters.AddItem(tempMonster);
		
		tempMonster.MClass = Class'kfgamecontent.KFPawn_ZedClot_Slasher';
		tempMonster.MinGr = 1;
		tempMonster.MaxGr = 4;
		tempMonster.MinWave = 0;
		tempMonster.MaxWave = 32;
		default.Zed_Monsters.AddItem(tempMonster);
		
		tempMonster.MClass = Class'kfgamecontent.KFPawn_ZedCrawler';
		tempMonster.MinGr = 1;
		tempMonster.MaxGr = 2;
		tempMonster.MinWave = 0;
		tempMonster.MaxWave = 999;
		default.Zed_Monsters.AddItem(tempMonster);
		
		tempMonster.MClass = Class'kfgamecontent.KFPawn_ZedStalker';
		tempMonster.MinGr = 1;
		tempMonster.MaxGr = 2;
		tempMonster.MinWave = 0;
		tempMonster.MaxWave = 999;
		default.Zed_Monsters.AddItem(tempMonster);
		
		tempMonster.MClass = Class'kfgamecontent.KFPawn_ZedGorefast';
		tempMonster.MinGr = 1;
		tempMonster.MaxGr = 2;
		tempMonster.MinWave = 0;
		tempMonster.MaxWave = 999;
		default.Zed_Monsters.AddItem(tempMonster);
	}
	if (default.MODEVERSION < 11)
	{
		for (i=0; i<default.Zed_Monsters.length; i+=1)
		{
			if (default.Zed_Monsters[i].MClass==Class'kfgamecontent.KFPawn_ZedClot_Alpha' && default.Zed_Monsters[i].MinWave == 0 && (default.Zed_Monsters[i].MaxWave == 4 || default.Zed_Monsters[i].MaxWave == 20))
				default.Zed_Monsters[i].MClass=Class'Zedternal.WMPawn_ZedClot_Alpha_NoRiot';
		}
	}
	if (default.MODEVERSION < 13)
	{
		// change husk max group
		for (i=0; i<default.Zed_Monsters.length; i+=1)
		{
			if (default.Zed_Monsters[i].MClass==Class'kfgamecontent.KFPawn_ZedHusk' && default.Zed_Monsters[i].MaxGr==3)
				default.Zed_Monsters[i].MaxGr = 2;
			else if (default.Zed_Monsters[i].MClass==Class'Zedternal.WMPawn_ZedHusk_Omega' && default.Zed_Monsters[i].MaxGr==5)
				default.Zed_Monsters[i].MaxGr = 4;
		}
		
		tempValue.ZedClass = Class'Zedternal.WMPawn_ZedHusk_Tiny_Green';
		tempValue.Value = 18;
		tempValue.ValuePerExtraPlayer = 0;
		default.Zed_Value.AddItem(tempValue);
		
		tempValue.ZedClass = Class'Zedternal.WMPawn_ZedHusk_Tiny_Blue';
		tempValue.Value = 18;
		tempValue.ValuePerExtraPlayer = 0;
		default.Zed_Value.AddItem(tempValue);
		
		tempValue.ZedClass = Class'Zedternal.WMPawn_ZedHusk_Tiny_Pink';
		tempValue.Value = 18;
		tempValue.ValuePerExtraPlayer = 0;
		default.Zed_Value.AddItem(tempValue);
		
		// Omega Fleshpound spawn earlier
		for (i=0; i<default.Zed_Monsters.length; i+=1)
		{
			if (default.Zed_Monsters[i].MClass==Class'Zedternal.WMPawn_ZedFleshpound_Omega' && default.Zed_Monsters[i].MinWave == 17)
				default.Zed_Monsters[i].MinWave = 15;
		}
		
		// Add Zedternal Gorefast
		for (i=0; i<default.Zed_Monsters.length; i+=1)
		{
			if (default.Zed_Monsters[i].MClass==Class'kfgamecontent.KFPawn_ZedGorefast')
				default.Zed_Monsters[i].MClass=Class'Zedternal.WMPawn_ZedGorefast_NoDualBlade';
		}
		tempValue.ZedClass = Class'Zedternal.WMPawn_ZedGorefast_NoDualBlade';
		tempValue.Value = 16;
		tempValue.ValuePerExtraPlayer = 0;
		default.Zed_Value.AddItem(tempValue);
		
		// Add Gorefast variant
		tempVariant.ZedClass = Class'Zedternal.WMPawn_ZedGorefast_NoDualBlade';
		tempVariant.VariantClass = Class'kfgamecontent.KFPawn_ZedGorefastDualBlade';
		tempVariant.probability = 0.100000;
		tempVariant.minDifficulty = 0;
		tempVariant.maxDifficulty = 0;
		default.Zed_ZedVariant.AddItem(tempVariant);
		
		tempVariant.probability = 0.250000;
		tempVariant.minDifficulty = 1;
		tempVariant.maxDifficulty = 1;
		default.Zed_ZedVariant.AddItem(tempVariant);
		
		tempVariant.probability = 0.350000;
		tempVariant.minDifficulty = 2;
		tempVariant.maxDifficulty = 4;
		default.Zed_ZedVariant.AddItem(tempVariant);
		
	}
	
	if (default.MODEVERSION < class'Zedternal.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'Zedternal.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}

}

static function int GetMonsterValue(class< KFPawn_Monster > KFPM, int NbPlayer)
{
	local int index;
	local int NbP;
	
	NbP = Max(1, NbPlayer);
	
	index = default.Zed_Value.Find('ZedClass', KFPM);
	if (index != -1)
		return default.Zed_Value[index].Value + default.Zed_Value[index].ValuePerExtraPlayer * (NbP-1);
	else
		return KFPM.static.GetDoshValue();
}


defaultproperties
{
}