class Config_Zed extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

var config int Zed_MaxDifferentMonster;

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
		ValuePerExtraPlayer = 0;
	}
};
var config array< SMonsterValue > Zed_Value;

struct SZedVariant
{
	var class<KFPawn_Monster> ZedClass;
	var class<KFPawn_Monster> VariantClass;
	var float probability;
	var int minDifficulty;
	var int maxDifficulty;
};
var config array< SZedVariant > Zed_ZedVariant;

var config bool Zed_bEnableWaveGroupInjection;

struct SZedSpawnGroup
{
	var array< class<KFPawn_Monster> > ZedClasses;
	var int WaveNum;
	var string Position;
	var int minDifficulty;
	var int maxDifficulty;
};
var config array<SZedSpawnGroup> Zed_ZedWaveGroupInject;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Zed_MaxDifferentMonster = 12;

		/////////////////////////////
		///////// ZED List //////////
		/////////////////////////////

		default.Zed_Monsters.length = 61;

		// Clots

		default.Zed_Monsters[0].MClass = Class'KFGameContent.KFPawn_ZedClot_Cyst';
		default.Zed_Monsters[0].MinWave = 0;
		default.Zed_Monsters[0].MaxWave = 2;
		default.Zed_Monsters[0].MinGr = 2;
		default.Zed_Monsters[0].MaxGr = 4;

		default.Zed_Monsters[1].MClass = Class'KFGameContent.KFPawn_ZedClot_Cyst';
		default.Zed_Monsters[1].MinWave = 0;
		default.Zed_Monsters[1].MaxWave = 7;
		default.Zed_Monsters[1].MinGr = 2;
		default.Zed_Monsters[1].MaxGr = 6;

		default.Zed_Monsters[2].MClass = Class'KFGameContent.KFPawn_ZedClot_Cyst';
		default.Zed_Monsters[2].MinWave = 0;
		default.Zed_Monsters[2].MaxWave = 16;
		default.Zed_Monsters[2].MinGr = 1;
		default.Zed_Monsters[2].MaxGr = 4;

		default.Zed_Monsters[3].MClass = Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
		default.Zed_Monsters[3].MinWave = 0;
		default.Zed_Monsters[3].MaxWave = 4;
		default.Zed_Monsters[3].MinGr = 1;
		default.Zed_Monsters[3].MaxGr = 4;

		default.Zed_Monsters[4].MClass = Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
		default.Zed_Monsters[4].MinWave = 0;
		default.Zed_Monsters[4].MaxWave = 20;
		default.Zed_Monsters[4].MinGr = 1;
		default.Zed_Monsters[4].MaxGr = 4;

		default.Zed_Monsters[5].MClass = Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
		default.Zed_Monsters[5].MinWave = 0;
		default.Zed_Monsters[5].MaxWave = 999;
		default.Zed_Monsters[5].MinGr = 2;
		default.Zed_Monsters[5].MaxGr = 6;

		default.Zed_Monsters[6].MClass = Class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		default.Zed_Monsters[6].MinWave = 17;
		default.Zed_Monsters[6].MaxWave = 999;
		default.Zed_Monsters[6].MinGr = 1;
		default.Zed_Monsters[6].MaxGr = 4;

		default.Zed_Monsters[7].MClass = Class'KFGameContent.KFPawn_ZedClot_Slasher';
		default.Zed_Monsters[7].MinWave = 0;
		default.Zed_Monsters[7].MaxWave = 2;
		default.Zed_Monsters[7].MinGr = 1;
		default.Zed_Monsters[7].MaxGr = 1;

		default.Zed_Monsters[8].MClass = Class'KFGameContent.KFPawn_ZedClot_Slasher';
		default.Zed_Monsters[8].MinWave = 0;
		default.Zed_Monsters[8].MaxWave = 8;
		default.Zed_Monsters[8].MinGr = 1;
		default.Zed_Monsters[8].MaxGr = 3;

		default.Zed_Monsters[9].MClass = Class'KFGameContent.KFPawn_ZedClot_Slasher';
		default.Zed_Monsters[9].MinWave = 0;
		default.Zed_Monsters[9].MaxWave = 15;
		default.Zed_Monsters[9].MinGr = 1;
		default.Zed_Monsters[9].MaxGr = 4;

		default.Zed_Monsters[10].MClass = Class'KFGameContent.KFPawn_ZedClot_Slasher';
		default.Zed_Monsters[10].MinWave = 0;
		default.Zed_Monsters[10].MaxWave = 32;
		default.Zed_Monsters[10].MinGr = 1;
		default.Zed_Monsters[10].MaxGr = 4;

		default.Zed_Monsters[11].MClass = Class'KFGameContent.KFPawn_ZedClot_Slasher';
		default.Zed_Monsters[11].MinWave = 2;
		default.Zed_Monsters[11].MaxWave = 999;
		default.Zed_Monsters[11].MinGr = 2;
		default.Zed_Monsters[11].MaxGr = 6;

		default.Zed_Monsters[12].MClass = Class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega';
		default.Zed_Monsters[12].MinWave = 9;
		default.Zed_Monsters[12].MaxWave = 999;
		default.Zed_Monsters[12].MinGr = 1;
		default.Zed_Monsters[12].MaxGr = 4;

		default.Zed_Monsters[13].MClass = Class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega';
		default.Zed_Monsters[13].MinWave = 17;
		default.Zed_Monsters[13].MaxWave = 999;
		default.Zed_Monsters[13].MinGr = 2;
		default.Zed_Monsters[13].MaxGr = 4;

		// Crawler

		default.Zed_Monsters[14].MClass = Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
		default.Zed_Monsters[14].MinWave = 0;
		default.Zed_Monsters[14].MaxWave = 999;
		default.Zed_Monsters[14].MinGr = 1;
		default.Zed_Monsters[14].MaxGr = 4;

		default.Zed_Monsters[15].MClass = Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
		default.Zed_Monsters[15].MinWave = 0;
		default.Zed_Monsters[15].MaxWave = 999;
		default.Zed_Monsters[15].MinGr = 1;
		default.Zed_Monsters[15].MaxGr = 2;

		default.Zed_Monsters[16].MClass = Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
		default.Zed_Monsters[16].MinWave = 4;
		default.Zed_Monsters[16].MaxWave = 999;
		default.Zed_Monsters[16].MinGr = 2;
		default.Zed_Monsters[16].MaxGr = 7;

		default.Zed_Monsters[17].MClass = Class'ZedternalReborn.WMPawn_ZedCrawler_Huge';
		default.Zed_Monsters[17].MinWave = 16;
		default.Zed_Monsters[17].MaxWave = 999;
		default.Zed_Monsters[17].MinGr = 1;
		default.Zed_Monsters[17].MaxGr = 1;

		// Stalker

		default.Zed_Monsters[18].MClass = Class'ZedternalReborn.WMPawn_ZedStalker_NoDAR';
		default.Zed_Monsters[18].MinWave = 0;
		default.Zed_Monsters[18].MaxWave = 999;
		default.Zed_Monsters[18].MinGr = 1;
		default.Zed_Monsters[18].MaxGr = 2;

		default.Zed_Monsters[19].MClass = Class'ZedternalReborn.WMPawn_ZedStalker_NoDAR';
		default.Zed_Monsters[19].MinWave = 2;
		default.Zed_Monsters[19].MaxWave = 5;
		default.Zed_Monsters[19].MinGr = 1;
		default.Zed_Monsters[19].MaxGr = 4;

		default.Zed_Monsters[20].MClass = Class'ZedternalReborn.WMPawn_ZedStalker_NoDAR';
		default.Zed_Monsters[20].MinWave = 4;
		default.Zed_Monsters[20].MaxWave = 999;
		default.Zed_Monsters[20].MinGr = 2;
		default.Zed_Monsters[20].MaxGr = 5;

		default.Zed_Monsters[21].MClass = Class'ZedternalReborn.WMPawn_ZedStalker_Omega';
		default.Zed_Monsters[21].MinWave = 11;
		default.Zed_Monsters[21].MaxWave = 999;
		default.Zed_Monsters[21].MinGr = 3;
		default.Zed_Monsters[21].MaxGr = 6;

		// Gorefast

		default.Zed_Monsters[22].MClass = Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_Monsters[22].MinWave = 0;
		default.Zed_Monsters[22].MaxWave = 3;
		default.Zed_Monsters[22].MinGr = 1;
		default.Zed_Monsters[22].MaxGr = 2;

		default.Zed_Monsters[23].MClass = Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_Monsters[23].MinWave = 0;
		default.Zed_Monsters[23].MaxWave = 999;
		default.Zed_Monsters[23].MinGr = 1;
		default.Zed_Monsters[23].MaxGr = 2;

		default.Zed_Monsters[24].MClass = Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_Monsters[24].MinWave = 2;
		default.Zed_Monsters[24].MaxWave = 999;
		default.Zed_Monsters[24].MinGr = 1;
		default.Zed_Monsters[24].MaxGr = 4;

		default.Zed_Monsters[25].MClass = Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_Monsters[25].MinWave = 4;
		default.Zed_Monsters[25].MaxWave = 999;
		default.Zed_Monsters[25].MinGr = 3;
		default.Zed_Monsters[25].MaxGr = 6;

		default.Zed_Monsters[26].MClass = Class'ZedternalReborn.WMPawn_ZedGorefast_Omega';
		default.Zed_Monsters[26].MinWave = 9;
		default.Zed_Monsters[26].MaxWave = 16;
		default.Zed_Monsters[26].MinGr = 1;
		default.Zed_Monsters[26].MaxGr = 1;

		default.Zed_Monsters[27].MClass = Class'ZedternalReborn.WMPawn_ZedGorefast_Omega';
		default.Zed_Monsters[27].MinWave = 13;
		default.Zed_Monsters[27].MaxWave = 999;
		default.Zed_Monsters[27].MinGr = 2;
		default.Zed_Monsters[27].MaxGr = 4;

		default.Zed_Monsters[28].MClass = Class'ZedternalReborn.WMPawn_ZedGorefast_Omega';
		default.Zed_Monsters[28].MinWave = 17;
		default.Zed_Monsters[28].MaxWave = 999;
		default.Zed_Monsters[28].MinGr = 4;
		default.Zed_Monsters[28].MaxGr = 8;

		// Bloat

		default.Zed_Monsters[29].MClass = Class'KFGameContent.KFPawn_ZedBloat';
		default.Zed_Monsters[29].MinWave = 2;
		default.Zed_Monsters[29].MaxWave = 4;
		default.Zed_Monsters[29].MinGr = 1;
		default.Zed_Monsters[29].MaxGr = 1;

		default.Zed_Monsters[30].MClass = Class'KFGameContent.KFPawn_ZedBloat';
		default.Zed_Monsters[30].MinWave = 4;
		default.Zed_Monsters[30].MaxWave = 999;
		default.Zed_Monsters[30].MinGr = 1;
		default.Zed_Monsters[30].MaxGr = 2;

		default.Zed_Monsters[31].MClass = Class'KFGameContent.KFPawn_ZedBloat';
		default.Zed_Monsters[31].MinWave = 9;
		default.Zed_Monsters[31].MaxWave = 999;
		default.Zed_Monsters[31].MinGr = 1;
		default.Zed_Monsters[31].MaxGr = 4;

		// Husk

		default.Zed_Monsters[32].MClass = Class'ZedternalReborn.WMPawn_ZedHusk_NoDAR';
		default.Zed_Monsters[32].MinWave = 2;
		default.Zed_Monsters[32].MaxWave = 5;
		default.Zed_Monsters[32].MinGr = 1;
		default.Zed_Monsters[32].MaxGr = 1;

		default.Zed_Monsters[33].MClass = Class'ZedternalReborn.WMPawn_ZedHusk_NoDAR';
		default.Zed_Monsters[33].MinWave = 5;
		default.Zed_Monsters[33].MaxWave = 999;
		default.Zed_Monsters[33].MinGr = 1;
		default.Zed_Monsters[33].MaxGr = 2;

		default.Zed_Monsters[34].MClass = Class'ZedternalReborn.WMPawn_ZedHusk_NoDAR';
		default.Zed_Monsters[34].MinWave = 9;
		default.Zed_Monsters[34].MaxWave = 999;
		default.Zed_Monsters[34].MinGr = 1;
		default.Zed_Monsters[34].MaxGr = 2;

		default.Zed_Monsters[35].MClass = Class'ZedternalReborn.WMPawn_ZedHusk_Omega';
		default.Zed_Monsters[35].MinWave = 13;
		default.Zed_Monsters[35].MaxWave = 999;
		default.Zed_Monsters[35].MinGr = 1;
		default.Zed_Monsters[35].MaxGr = 2;

		default.Zed_Monsters[36].MClass = Class'ZedternalReborn.WMPawn_ZedHusk_Omega';
		default.Zed_Monsters[36].MinWave = 17;
		default.Zed_Monsters[36].MaxWave = 999;
		default.Zed_Monsters[36].MinGr = 1;
		default.Zed_Monsters[36].MaxGr = 4;

		// Siren

		default.Zed_Monsters[37].MClass = Class'KFGameContent.KFPawn_ZedSiren';
		default.Zed_Monsters[37].MinWave = 3;
		default.Zed_Monsters[37].MaxWave = 23;
		default.Zed_Monsters[37].MinGr = 1;
		default.Zed_Monsters[37].MaxGr = 1;

		default.Zed_Monsters[38].MClass = Class'KFGameContent.KFPawn_ZedSiren';
		default.Zed_Monsters[38].MinWave = 7;
		default.Zed_Monsters[38].MaxWave = 999;
		default.Zed_Monsters[38].MinGr = 1;
		default.Zed_Monsters[38].MaxGr = 2;

		default.Zed_Monsters[39].MClass = Class'ZedternalReborn.WMPawn_ZedSiren_Omega';
		default.Zed_Monsters[39].MinWave = 23;
		default.Zed_Monsters[39].MaxWave = 999;
		default.Zed_Monsters[39].MinGr = 1;
		default.Zed_Monsters[39].MaxGr = 2;

		// Fleshpound Mini

		default.Zed_Monsters[40].MClass = Class'KFGameContent.KFPawn_ZedFleshpoundMini';
		default.Zed_Monsters[40].MinWave = 4;
		default.Zed_Monsters[40].MaxWave = 10;
		default.Zed_Monsters[40].MinGr = 1;
		default.Zed_Monsters[40].MaxGr = 1;

		default.Zed_Monsters[41].MClass = Class'KFGameContent.KFPawn_ZedFleshpoundMini';
		default.Zed_Monsters[41].MinWave = 9;
		default.Zed_Monsters[41].MaxWave = 15;
		default.Zed_Monsters[41].MinGr = 1;
		default.Zed_Monsters[41].MaxGr = 1;

		// Scrake

		default.Zed_Monsters[42].MClass = Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_Monsters[42].MinWave = 2;
		default.Zed_Monsters[42].MaxWave = 5;
		default.Zed_Monsters[42].MinGr = 1;
		default.Zed_Monsters[42].MaxGr = 1;

		default.Zed_Monsters[43].MClass = Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_Monsters[43].MinWave = 5;
		default.Zed_Monsters[43].MaxWave = 999;
		default.Zed_Monsters[43].MinGr = 1;
		default.Zed_Monsters[43].MaxGr = 2;

		default.Zed_Monsters[44].MClass = Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_Monsters[44].MinWave = 8;
		default.Zed_Monsters[44].MaxWave = 15;
		default.Zed_Monsters[44].MinGr = 1;
		default.Zed_Monsters[44].MaxGr = 3;

		default.Zed_Monsters[45].MClass = Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_Monsters[45].MinWave = 13;
		default.Zed_Monsters[45].MaxWave = 999;
		default.Zed_Monsters[45].MinGr = 1;
		default.Zed_Monsters[45].MaxGr = 4;

		default.Zed_Monsters[46].MClass = Class'ZedternalReborn.WMPawn_ZedScrake_Omega';
		default.Zed_Monsters[46].MinWave = 13;
		default.Zed_Monsters[46].MaxWave = 30;
		default.Zed_Monsters[46].MinGr = 1;
		default.Zed_Monsters[46].MaxGr = 1;

		default.Zed_Monsters[47].MClass = Class'ZedternalReborn.WMPawn_ZedScrake_Omega';
		default.Zed_Monsters[47].MinWave = 17;
		default.Zed_Monsters[47].MaxWave = 999;
		default.Zed_Monsters[47].MinGr = 1;
		default.Zed_Monsters[47].MaxGr = 2;

		default.Zed_Monsters[48].MClass = Class'ZedternalReborn.WMPawn_ZedScrake_Omega';
		default.Zed_Monsters[48].MinWave = 21;
		default.Zed_Monsters[48].MaxWave = 999;
		default.Zed_Monsters[48].MinGr = 1;
		default.Zed_Monsters[48].MaxGr = 4;

		default.Zed_Monsters[49].MClass = Class'ZedternalReborn.WMPawn_ZedScrake_Omega';
		default.Zed_Monsters[49].MinWave = 25;
		default.Zed_Monsters[49].MaxWave = 999;
		default.Zed_Monsters[49].MinGr = 2;
		default.Zed_Monsters[49].MaxGr = 6;

		// Fleshpound

		default.Zed_Monsters[50].MClass = Class'KFGameContent.KFPawn_ZedFleshpound';
		default.Zed_Monsters[50].MinWave = 5;
		default.Zed_Monsters[50].MaxWave = 999;
		default.Zed_Monsters[50].MinGr = 1;
		default.Zed_Monsters[50].MaxGr = 1;

		default.Zed_Monsters[51].MClass = Class'KFGameContent.KFPawn_ZedFleshpound';
		default.Zed_Monsters[51].MinWave = 8;
		default.Zed_Monsters[51].MaxWave = 999;
		default.Zed_Monsters[51].MinGr = 1;
		default.Zed_Monsters[51].MaxGr = 2;

		default.Zed_Monsters[52].MClass = Class'ZedternalReborn.WMPawn_ZedFleshpound_Omega';
		default.Zed_Monsters[52].MinWave = 15;
		default.Zed_Monsters[52].MaxWave = 27;
		default.Zed_Monsters[52].MinGr = 1;
		default.Zed_Monsters[52].MaxGr = 1;

		default.Zed_Monsters[53].MClass = Class'ZedternalReborn.WMPawn_ZedFleshpound_Omega';
		default.Zed_Monsters[53].MinWave = 19;
		default.Zed_Monsters[53].MaxWave = 999;
		default.Zed_Monsters[53].MinGr = 1;
		default.Zed_Monsters[53].MaxGr = 2;

		default.Zed_Monsters[54].MClass = Class'ZedternalReborn.WMPawn_ZedFleshpound_Omega';
		default.Zed_Monsters[54].MinWave = 22;
		default.Zed_Monsters[54].MaxWave = 999;
		default.Zed_Monsters[54].MinGr = 2;
		default.Zed_Monsters[54].MaxGr = 3;

		// Additional spawns

		default.Zed_Monsters[55].MClass = Class'KFGameContent.KFPawn_ZedDAR_Rocket';
		default.Zed_Monsters[55].MinWave = 9;
		default.Zed_Monsters[55].MaxWave = 999;
		default.Zed_Monsters[55].MinGr = 1;
		default.Zed_Monsters[55].MaxGr = 1;

		default.Zed_Monsters[56].MClass = Class'KFGameContent.KFPawn_ZedBloatKingSubspawn';
		default.Zed_Monsters[56].MinWave = 12;
		default.Zed_Monsters[56].MaxWave = 999;
		default.Zed_Monsters[56].MinGr = 1;
		default.Zed_Monsters[56].MaxGr = 1;

		// Bosses

		default.Zed_Monsters[57].MClass = Class'ZedternalReborn.WMPawn_ZedPatriarch';
		default.Zed_Monsters[57].MinWave = 17;
		default.Zed_Monsters[57].MaxWave = 999;
		default.Zed_Monsters[57].MinGr = 1;
		default.Zed_Monsters[57].MaxGr = 1;

		default.Zed_Monsters[58].MClass = Class'ZedternalReborn.WMPawn_ZedFleshpoundKing';
		default.Zed_Monsters[58].MinWave = 21;
		default.Zed_Monsters[58].MaxWave = 999;
		default.Zed_Monsters[58].MinGr = 1;
		default.Zed_Monsters[58].MaxGr = 1;

		default.Zed_Monsters[59].MClass = Class'ZedternalReborn.WMPawn_ZedFleshpoundKing';
		default.Zed_Monsters[59].MinWave = 25;
		default.Zed_Monsters[59].MaxWave = 999;
		default.Zed_Monsters[59].MinGr = 1;
		default.Zed_Monsters[59].MaxGr = 1;

		default.Zed_Monsters[60].MClass = Class'ZedternalReborn.WMPawn_ZedPatriarch';
		default.Zed_Monsters[60].MinWave = 29;
		default.Zed_Monsters[60].MaxWave = 999;
		default.Zed_Monsters[60].MinGr = 1;
		default.Zed_Monsters[60].MaxGr = 1;

		/////////////////////////////
		/////// ZEDs Values /////////
		/////////////////////////////

		default.Zed_Value.length = 45;

		// Clots

		default.Zed_Value[0].ZedClass = Class'KFGameContent.KFPawn_ZedClot_Cyst';
		default.Zed_Value[0].Value = 6;

		default.Zed_Value[1].ZedClass = Class'KFGameContent.KFPawn_ZedClot_Alpha';
		default.Zed_Value[1].Value = 6;

		default.Zed_Value[2].ZedClass = Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
		default.Zed_Value[2].Value = 6;

		default.Zed_Value[3].ZedClass = Class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		default.Zed_Value[3].Value = 20;

		default.Zed_Value[4].ZedClass = Class'KFGameContent.KFPawn_ZedClot_Slasher';
		default.Zed_Value[4].Value = 7;

		default.Zed_Value[5].ZedClass = Class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega';
		default.Zed_Value[5].Value = 24;

		//Crawler

		default.Zed_Value[6].ZedClass = Class'KFGameContent.KFPawn_ZedCrawler';
		default.Zed_Value[6].Value = 8;

		default.Zed_Value[7].ZedClass = Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
		default.Zed_Value[7].Value = 8;

		default.Zed_Value[8].ZedClass = Class'KFGameContent.KFPawn_ZedCrawlerKing';
		default.Zed_Value[8].Value = 20;

		default.Zed_Value[9].ZedClass = Class'ZedternalReborn.WMPawn_ZedCrawler_Mini';
		default.Zed_Value[9].Value = 5;

		default.Zed_Value[10].ZedClass = Class'ZedternalReborn.WMPawn_ZedCrawler_Medium';
		default.Zed_Value[10].Value = 7;

		default.Zed_Value[11].ZedClass = Class'ZedternalReborn.WMPawn_ZedCrawler_Big';
		default.Zed_Value[11].Value = 20;

		default.Zed_Value[12].ZedClass = Class'ZedternalReborn.WMPawn_ZedCrawler_Huge';
		default.Zed_Value[12].Value = 45;

		default.Zed_Value[13].ZedClass = Class'ZedternalReborn.WMPawn_ZedCrawler_Ultra';
		default.Zed_Value[13].Value = 75;

		// Gorefast

		default.Zed_Value[14].ZedClass = Class'KFGameContent.KFPawn_ZedGorefast';
		default.Zed_Value[14].Value = 16;

		default.Zed_Value[15].ZedClass = Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_Value[15].Value = 16;

		default.Zed_Value[16].ZedClass = Class'KFGameContent.KFPawn_ZedGorefastDualBlade';
		default.Zed_Value[16].Value = 35;

		default.Zed_Value[17].ZedClass = Class'ZedternalReborn.WMPawn_ZedGorefast_Omega';
		default.Zed_Value[17].Value = 40;

		// Stalker

		default.Zed_Value[18].ZedClass = Class'KFGameContent.KFPawn_ZedStalker';
		default.Zed_Value[18].Value = 10;

		default.Zed_Value[19].ZedClass = Class'ZedternalReborn.WMPawn_ZedStalker_NoDAR';
		default.Zed_Value[19].Value = 10;

		default.Zed_Value[20].ZedClass = Class'ZedternalReborn.WMPawn_ZedStalker_Omega';
		default.Zed_Value[20].Value = 25;

		// Bloat

		default.Zed_Value[21].ZedClass = Class'KFGameContent.KFPawn_ZedBloat';
		default.Zed_Value[21].Value = 25;

		default.Zed_Value[22].ZedClass = Class'KFGameContent.KFPawn_ZedBloatKingSubspawn';
		default.Zed_Value[22].Value = 15;

		// Husk

		default.Zed_Value[23].ZedClass = Class'KFGameContent.KFPawn_ZedHusk';
		default.Zed_Value[23].Value = 25;

		default.Zed_Value[24].ZedClass = Class'ZedternalReborn.WMPawn_ZedHusk_NoDAR';
		default.Zed_Value[24].Value = 25;

		default.Zed_Value[25].ZedClass = Class'ZedternalReborn.WMPawn_ZedHusk_Tiny_Green';
		default.Zed_Value[25].Value = 18;

		default.Zed_Value[26].ZedClass = Class'ZedternalReborn.WMPawn_ZedHusk_Tiny_Blue';
		default.Zed_Value[26].Value = 18;

		default.Zed_Value[27].ZedClass = Class'ZedternalReborn.WMPawn_ZedHusk_Tiny_Pink';
		default.Zed_Value[27].Value = 18;

		default.Zed_Value[28].ZedClass = Class'ZedternalReborn.WMPawn_ZedHusk_Omega';
		default.Zed_Value[28].Value = 70;

		// Siren

		default.Zed_Value[29].ZedClass = Class'KFGameContent.KFPawn_ZedSiren';
		default.Zed_Value[29].Value = 30;

		default.Zed_Value[30].ZedClass = Class'ZedternalReborn.WMPawn_ZedSiren_Omega';
		default.Zed_Value[30].Value = 50;
		default.Zed_Value[30].ValuePerExtraPlayer = 3;

		// DAR

		default.Zed_Value[31].ZedClass = Class'KFGameContent.KFPawn_ZedDAR_Rocket';
		default.Zed_Value[31].Value = 45;

		default.Zed_Value[32].ZedClass = Class'KFGameContent.KFPawn_ZedDAR_Laser';
		default.Zed_Value[32].Value = 45;

		default.Zed_Value[33].ZedClass = Class'KFGameContent.KFPawn_ZedDAR_EMP';
		default.Zed_Value[33].Value = 45;

		// Scrake

		default.Zed_Value[34].ZedClass = Class'ZedternalReborn.WMPawn_ZedScrake_Tiny';
		default.Zed_Value[34].Value = 80;

		default.Zed_Value[35].ZedClass = Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_Value[35].Value = 110;
		default.Zed_Value[35].ValuePerExtraPlayer = 9;

		default.Zed_Value[36].ZedClass = Class'ZedternalReborn.WMPawn_ZedScrake_Omega';
		default.Zed_Value[36].Value = 400;
		default.Zed_Value[36].ValuePerExtraPlayer = 32;

		// Fleshpound

		default.Zed_Value[37].ZedClass = Class'KFGameContent.KFPawn_ZedFleshpoundMini';
		default.Zed_Value[37].Value = 100;
		default.Zed_Value[37].ValuePerExtraPlayer = 8;

		default.Zed_Value[38].ZedClass = Class'KFGameContent.KFPawn_ZedFleshpound';
		default.Zed_Value[38].Value = 175;
		default.Zed_Value[38].ValuePerExtraPlayer = 14;

		default.Zed_Value[39].ZedClass = Class'ZedternalReborn.WMPawn_ZedFleshpound_Omega';
		default.Zed_Value[39].Value = 400;
		default.Zed_Value[39].ValuePerExtraPlayer = 32;

		// Bosses

		default.Zed_Value[40].ZedClass = Class'ZedternalReborn.WMPawn_ZedFleshpoundKing';
		default.Zed_Value[40].Value = 2400;
		default.Zed_Value[40].ValuePerExtraPlayer = 200;

		default.Zed_Value[41].ZedClass = Class'ZedternalReborn.WMPawn_ZedPatriarch';
		default.Zed_Value[41].Value = 2400;
		default.Zed_Value[41].ValuePerExtraPlayer = 200;

		default.Zed_Value[42].ZedClass = Class'ZedternalReborn.WMPawn_ZedMatriarch';
		default.Zed_Value[42].Value = 2400;
		default.Zed_Value[42].ValuePerExtraPlayer = 200;

		default.Zed_Value[43].ZedClass = Class'ZedternalReborn.WMPawn_ZedHans';
		default.Zed_Value[43].Value = 2400;
		default.Zed_Value[43].ValuePerExtraPlayer = 200;

		default.Zed_Value[44].ZedClass = Class'ZedternalReborn.WMPawn_ZedBloatKing';
		default.Zed_Value[44].Value = 2400;
		default.Zed_Value[44].ValuePerExtraPlayer = 200;

		/////////////////////////////
		/////// Variant List ////////
		/////////////////////////////

		default.Zed_ZedVariant.length = 15;

		//Crawler

		default.Zed_ZedVariant[0].ZedClass = Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
		default.Zed_ZedVariant[0].VariantClass = Class'KFGameContent.KFPawn_ZedCrawlerKing';
		default.Zed_ZedVariant[0].probability = 0.050000;
		default.Zed_ZedVariant[0].minDifficulty = 0;
		default.Zed_ZedVariant[0].maxDifficulty = 0;

		default.Zed_ZedVariant[1].ZedClass = Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
		default.Zed_ZedVariant[1].VariantClass = Class'KFGameContent.KFPawn_ZedCrawlerKing';
		default.Zed_ZedVariant[1].probability = 0.100000;
		default.Zed_ZedVariant[1].minDifficulty = 1;
		default.Zed_ZedVariant[1].maxDifficulty = 1;

		default.Zed_ZedVariant[2].ZedClass = Class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
		default.Zed_ZedVariant[2].VariantClass = Class'KFGameContent.KFPawn_ZedCrawlerKing';
		default.Zed_ZedVariant[2].probability = 0.200000;
		default.Zed_ZedVariant[2].minDifficulty = 2;
		default.Zed_ZedVariant[2].maxDifficulty = 4;

		// Alpha clot

		default.Zed_ZedVariant[3].ZedClass = Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
		default.Zed_ZedVariant[3].VariantClass = Class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		default.Zed_ZedVariant[3].probability = 0.100000;
		default.Zed_ZedVariant[3].minDifficulty = 0;
		default.Zed_ZedVariant[3].maxDifficulty = 0;

		default.Zed_ZedVariant[4].ZedClass = Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
		default.Zed_ZedVariant[4].VariantClass = Class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		default.Zed_ZedVariant[4].probability = 0.200000;
		default.Zed_ZedVariant[4].minDifficulty = 1;
		default.Zed_ZedVariant[4].maxDifficulty = 1;

		default.Zed_ZedVariant[5].ZedClass = Class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
		default.Zed_ZedVariant[5].VariantClass = Class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		default.Zed_ZedVariant[5].probability = 0.300000;
		default.Zed_ZedVariant[5].minDifficulty = 2;
		default.Zed_ZedVariant[5].maxDifficulty = 4;

		// Gorefast

		default.Zed_ZedVariant[6].ZedClass = Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_ZedVariant[6].VariantClass = Class'KFGameContent.KFPawn_ZedGorefastDualBlade';
		default.Zed_ZedVariant[6].probability = 0.100000;
		default.Zed_ZedVariant[6].minDifficulty = 0;
		default.Zed_ZedVariant[6].maxDifficulty = 0;

		default.Zed_ZedVariant[7].ZedClass = Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_ZedVariant[7].VariantClass = Class'KFGameContent.KFPawn_ZedGorefastDualBlade';
		default.Zed_ZedVariant[7].probability = 0.250000;
		default.Zed_ZedVariant[7].minDifficulty = 1;
		default.Zed_ZedVariant[7].maxDifficulty = 1;

		default.Zed_ZedVariant[8].ZedClass = Class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_ZedVariant[8].VariantClass = Class'KFGameContent.KFPawn_ZedGorefastDualBlade';
		default.Zed_ZedVariant[8].probability = 0.350000;
		default.Zed_ZedVariant[8].minDifficulty = 2;
		default.Zed_ZedVariant[8].maxDifficulty = 4;

		// Scrake

		default.Zed_ZedVariant[9].ZedClass = Class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_ZedVariant[9].VariantClass = Class'ZedternalReborn.WMPawn_ZedScrake_Tiny';
		default.Zed_ZedVariant[9].probability = 0.010000;
		default.Zed_ZedVariant[9].minDifficulty = 0;
		default.Zed_ZedVariant[9].maxDifficulty = 4;

		// DAR

		default.Zed_ZedVariant[10].ZedClass = Class'KFGameContent.KFPawn_ZedDAR_Rocket';
		default.Zed_ZedVariant[10].VariantClass = Class'KFGameContent.KFPawn_ZedDAR_EMP';
		default.Zed_ZedVariant[10].probability = 0.333333;
		default.Zed_ZedVariant[10].minDifficulty = 0;
		default.Zed_ZedVariant[10].maxDifficulty = 4;

		default.Zed_ZedVariant[11].ZedClass = Class'KFGameContent.KFPawn_ZedDAR_Rocket';
		default.Zed_ZedVariant[11].VariantClass = Class'KFGameContent.KFPawn_ZedDAR_Laser';
		default.Zed_ZedVariant[11].probability = 0.333333;
		default.Zed_ZedVariant[11].minDifficulty = 0;
		default.Zed_ZedVariant[11].maxDifficulty = 4;

		// Bosses

		default.Zed_ZedVariant[12].ZedClass = Class'ZedternalReborn.WMPawn_ZedPatriarch';
		default.Zed_ZedVariant[12].VariantClass = Class'ZedternalReborn.WMPawn_ZedHans';
		default.Zed_ZedVariant[12].probability = 0.333333;
		default.Zed_ZedVariant[12].minDifficulty = 0;
		default.Zed_ZedVariant[12].maxDifficulty = 4;

		default.Zed_ZedVariant[13].ZedClass = Class'ZedternalReborn.WMPawn_ZedPatriarch';
		default.Zed_ZedVariant[13].VariantClass = Class'ZedternalReborn.WMPawn_ZedMatriarch';
		default.Zed_ZedVariant[13].probability = 0.333333;
		default.Zed_ZedVariant[13].minDifficulty = 0;
		default.Zed_ZedVariant[13].maxDifficulty = 4;

		default.Zed_ZedVariant[14].ZedClass = Class'ZedternalReborn.WMPawn_ZedFleshpoundKing';
		default.Zed_ZedVariant[14].VariantClass = Class'ZedternalReborn.WMPawn_ZedBloatKing';
		default.Zed_ZedVariant[14].probability = 0.500000;
		default.Zed_ZedVariant[14].minDifficulty = 0;
		default.Zed_ZedVariant[14].maxDifficulty = 4;
	}

	if (default.MODEVERSION < 10)
	{
		default.Zed_bEnableWaveGroupInjection = false;

		default.Zed_ZedWaveGroupInject.length = 1;
		default.Zed_ZedWaveGroupInject[0].ZedClasses.length = 3;

		default.Zed_ZedWaveGroupInject[0].ZedClasses[0] = Class'ZedternalReborn.WMPawn_ZedCrawler_Ultra';
		default.Zed_ZedWaveGroupInject[0].ZedClasses[1] = Class'ZedternalReborn.WMPawn_ZedCrawler_Ultra';
		default.Zed_ZedWaveGroupInject[0].ZedClasses[2] = Class'ZedternalReborn.WMPawn_ZedCrawler_Ultra';
		default.Zed_ZedWaveGroupInject[0].WaveNum = 10;
		default.Zed_ZedWaveGroupInject[0].Position = "END";
		default.Zed_ZedWaveGroupInject[0].minDifficulty = 0;
		default.Zed_ZedWaveGroupInject[0].maxDifficulty = 4;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
}

static function int GetMonsterValue(class< KFPawn_Monster > KFPM, int NbPlayer)
{
	local int index;
	local int NbP;

	NbP = Max(1, NbPlayer);

	index = default.Zed_Value.Find('ZedClass', KFPM);
	if (index != INDEX_NONE)
		return default.Zed_Value[index].Value + default.Zed_Value[index].ValuePerExtraPlayer * (NbP - 1);
	else
		return KFPM.static.GetDoshValue();
}

defaultproperties
{
}
