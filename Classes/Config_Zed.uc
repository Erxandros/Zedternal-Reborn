class Config_Zed extends Config_Common
	config(ZedternalReborn_ZedWaves);

var config int MODEVERSION;

struct S_ZedWave
{
	var string ZedPath;
	var int MinWave, MaxWave;
	var int MinGr, MaxGr;
};
var config array<S_ZedWave> Zed_Wave;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Zed_Wave.Length = 61;

		// Clots

		default.Zed_Wave[0].ZedPath = "KFGameContent.KFPawn_ZedClot_Cyst";
		default.Zed_Wave[0].MinWave = 0;
		default.Zed_Wave[0].MaxWave = 2;
		default.Zed_Wave[0].MinGr = 2;
		default.Zed_Wave[0].MaxGr = 4;

		default.Zed_Wave[1].ZedPath = "KFGameContent.KFPawn_ZedClot_Cyst";
		default.Zed_Wave[1].MinWave = 0;
		default.Zed_Wave[1].MaxWave = 7;
		default.Zed_Wave[1].MinGr = 2;
		default.Zed_Wave[1].MaxGr = 6;

		default.Zed_Wave[2].ZedPath = "KFGameContent.KFPawn_ZedClot_Cyst";
		default.Zed_Wave[2].MinWave = 0;
		default.Zed_Wave[2].MaxWave = 16;
		default.Zed_Wave[2].MinGr = 1;
		default.Zed_Wave[2].MaxGr = 4;

		default.Zed_Wave[3].ZedPath = "ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot";
		default.Zed_Wave[3].MinWave = 0;
		default.Zed_Wave[3].MaxWave = 4;
		default.Zed_Wave[3].MinGr = 1;
		default.Zed_Wave[3].MaxGr = 4;

		default.Zed_Wave[4].ZedPath = "ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot";
		default.Zed_Wave[4].MinWave = 0;
		default.Zed_Wave[4].MaxWave = 20;
		default.Zed_Wave[4].MinGr = 1;
		default.Zed_Wave[4].MaxGr = 4;

		default.Zed_Wave[5].ZedPath = "ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot";
		default.Zed_Wave[5].MinWave = 0;
		default.Zed_Wave[5].MaxWave = 999;
		default.Zed_Wave[5].MinGr = 2;
		default.Zed_Wave[5].MaxGr = 6;

		default.Zed_Wave[6].ZedPath = "KFGameContent.KFPawn_ZedClot_AlphaKing";
		default.Zed_Wave[6].MinWave = 17;
		default.Zed_Wave[6].MaxWave = 999;
		default.Zed_Wave[6].MinGr = 1;
		default.Zed_Wave[6].MaxGr = 4;

		default.Zed_Wave[7].ZedPath = "KFGameContent.KFPawn_ZedClot_Slasher";
		default.Zed_Wave[7].MinWave = 0;
		default.Zed_Wave[7].MaxWave = 2;
		default.Zed_Wave[7].MinGr = 1;
		default.Zed_Wave[7].MaxGr = 1;

		default.Zed_Wave[8].ZedPath = "KFGameContent.KFPawn_ZedClot_Slasher";
		default.Zed_Wave[8].MinWave = 0;
		default.Zed_Wave[8].MaxWave = 8;
		default.Zed_Wave[8].MinGr = 1;
		default.Zed_Wave[8].MaxGr = 3;

		default.Zed_Wave[9].ZedPath = "KFGameContent.KFPawn_ZedClot_Slasher";
		default.Zed_Wave[9].MinWave = 0;
		default.Zed_Wave[9].MaxWave = 15;
		default.Zed_Wave[9].MinGr = 1;
		default.Zed_Wave[9].MaxGr = 4;

		default.Zed_Wave[10].ZedPath = "KFGameContent.KFPawn_ZedClot_Slasher";
		default.Zed_Wave[10].MinWave = 0;
		default.Zed_Wave[10].MaxWave = 32;
		default.Zed_Wave[10].MinGr = 1;
		default.Zed_Wave[10].MaxGr = 4;

		default.Zed_Wave[11].ZedPath = "KFGameContent.KFPawn_ZedClot_Slasher";
		default.Zed_Wave[11].MinWave = 2;
		default.Zed_Wave[11].MaxWave = 999;
		default.Zed_Wave[11].MinGr = 2;
		default.Zed_Wave[11].MaxGr = 6;

		default.Zed_Wave[12].ZedPath = "ZedternalReborn.WMPawn_ZedClot_Slasher_Omega";
		default.Zed_Wave[12].MinWave = 9;
		default.Zed_Wave[12].MaxWave = 999;
		default.Zed_Wave[12].MinGr = 1;
		default.Zed_Wave[12].MaxGr = 4;

		default.Zed_Wave[13].ZedPath = "ZedternalReborn.WMPawn_ZedClot_Slasher_Omega";
		default.Zed_Wave[13].MinWave = 17;
		default.Zed_Wave[13].MaxWave = 999;
		default.Zed_Wave[13].MinGr = 2;
		default.Zed_Wave[13].MaxGr = 4;

		// Crawler

		default.Zed_Wave[14].ZedPath = "ZedternalReborn.WMPawn_ZedCrawler_NoElite";
		default.Zed_Wave[14].MinWave = 0;
		default.Zed_Wave[14].MaxWave = 999;
		default.Zed_Wave[14].MinGr = 1;
		default.Zed_Wave[14].MaxGr = 4;

		default.Zed_Wave[15].ZedPath = "ZedternalReborn.WMPawn_ZedCrawler_NoElite";
		default.Zed_Wave[15].MinWave = 0;
		default.Zed_Wave[15].MaxWave = 999;
		default.Zed_Wave[15].MinGr = 1;
		default.Zed_Wave[15].MaxGr = 2;

		default.Zed_Wave[16].ZedPath = "ZedternalReborn.WMPawn_ZedCrawler_NoElite";
		default.Zed_Wave[16].MinWave = 4;
		default.Zed_Wave[16].MaxWave = 999;
		default.Zed_Wave[16].MinGr = 2;
		default.Zed_Wave[16].MaxGr = 7;

		default.Zed_Wave[17].ZedPath = "ZedternalReborn.WMPawn_ZedCrawler_Huge";
		default.Zed_Wave[17].MinWave = 16;
		default.Zed_Wave[17].MaxWave = 999;
		default.Zed_Wave[17].MinGr = 1;
		default.Zed_Wave[17].MaxGr = 1;

		// Stalker

		default.Zed_Wave[18].ZedPath = "ZedternalReborn.WMPawn_ZedStalker_NoDAR";
		default.Zed_Wave[18].MinWave = 0;
		default.Zed_Wave[18].MaxWave = 999;
		default.Zed_Wave[18].MinGr = 1;
		default.Zed_Wave[18].MaxGr = 2;

		default.Zed_Wave[19].ZedPath = "ZedternalReborn.WMPawn_ZedStalker_NoDAR";
		default.Zed_Wave[19].MinWave = 2;
		default.Zed_Wave[19].MaxWave = 5;
		default.Zed_Wave[19].MinGr = 1;
		default.Zed_Wave[19].MaxGr = 4;

		default.Zed_Wave[20].ZedPath = "ZedternalReborn.WMPawn_ZedStalker_NoDAR";
		default.Zed_Wave[20].MinWave = 4;
		default.Zed_Wave[20].MaxWave = 999;
		default.Zed_Wave[20].MinGr = 2;
		default.Zed_Wave[20].MaxGr = 5;

		default.Zed_Wave[21].ZedPath = "ZedternalReborn.WMPawn_ZedStalker_Omega";
		default.Zed_Wave[21].MinWave = 11;
		default.Zed_Wave[21].MaxWave = 999;
		default.Zed_Wave[21].MinGr = 3;
		default.Zed_Wave[21].MaxGr = 6;

		// Gorefast

		default.Zed_Wave[22].ZedPath = "ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade";
		default.Zed_Wave[22].MinWave = 0;
		default.Zed_Wave[22].MaxWave = 3;
		default.Zed_Wave[22].MinGr = 1;
		default.Zed_Wave[22].MaxGr = 2;

		default.Zed_Wave[23].ZedPath = "ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade";
		default.Zed_Wave[23].MinWave = 0;
		default.Zed_Wave[23].MaxWave = 999;
		default.Zed_Wave[23].MinGr = 1;
		default.Zed_Wave[23].MaxGr = 2;

		default.Zed_Wave[24].ZedPath = "ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade";
		default.Zed_Wave[24].MinWave = 2;
		default.Zed_Wave[24].MaxWave = 999;
		default.Zed_Wave[24].MinGr = 1;
		default.Zed_Wave[24].MaxGr = 4;

		default.Zed_Wave[25].ZedPath = "ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade";
		default.Zed_Wave[25].MinWave = 4;
		default.Zed_Wave[25].MaxWave = 999;
		default.Zed_Wave[25].MinGr = 3;
		default.Zed_Wave[25].MaxGr = 6;

		default.Zed_Wave[26].ZedPath = "ZedternalReborn.WMPawn_ZedGorefast_Omega";
		default.Zed_Wave[26].MinWave = 9;
		default.Zed_Wave[26].MaxWave = 16;
		default.Zed_Wave[26].MinGr = 1;
		default.Zed_Wave[26].MaxGr = 1;

		default.Zed_Wave[27].ZedPath = "ZedternalReborn.WMPawn_ZedGorefast_Omega";
		default.Zed_Wave[27].MinWave = 13;
		default.Zed_Wave[27].MaxWave = 999;
		default.Zed_Wave[27].MinGr = 2;
		default.Zed_Wave[27].MaxGr = 4;

		default.Zed_Wave[28].ZedPath = "ZedternalReborn.WMPawn_ZedGorefast_Omega";
		default.Zed_Wave[28].MinWave = 17;
		default.Zed_Wave[28].MaxWave = 999;
		default.Zed_Wave[28].MinGr = 4;
		default.Zed_Wave[28].MaxGr = 8;

		// Bloat

		default.Zed_Wave[29].ZedPath = "KFGameContent.KFPawn_ZedBloat";
		default.Zed_Wave[29].MinWave = 2;
		default.Zed_Wave[29].MaxWave = 4;
		default.Zed_Wave[29].MinGr = 1;
		default.Zed_Wave[29].MaxGr = 1;

		default.Zed_Wave[30].ZedPath = "KFGameContent.KFPawn_ZedBloat";
		default.Zed_Wave[30].MinWave = 4;
		default.Zed_Wave[30].MaxWave = 999;
		default.Zed_Wave[30].MinGr = 1;
		default.Zed_Wave[30].MaxGr = 2;

		default.Zed_Wave[31].ZedPath = "KFGameContent.KFPawn_ZedBloat";
		default.Zed_Wave[31].MinWave = 9;
		default.Zed_Wave[31].MaxWave = 999;
		default.Zed_Wave[31].MinGr = 1;
		default.Zed_Wave[31].MaxGr = 4;

		// Husk

		default.Zed_Wave[32].ZedPath = "ZedternalReborn.WMPawn_ZedHusk_NoDAR";
		default.Zed_Wave[32].MinWave = 2;
		default.Zed_Wave[32].MaxWave = 5;
		default.Zed_Wave[32].MinGr = 1;
		default.Zed_Wave[32].MaxGr = 1;

		default.Zed_Wave[33].ZedPath = "ZedternalReborn.WMPawn_ZedHusk_NoDAR";
		default.Zed_Wave[33].MinWave = 5;
		default.Zed_Wave[33].MaxWave = 999;
		default.Zed_Wave[33].MinGr = 1;
		default.Zed_Wave[33].MaxGr = 2;

		default.Zed_Wave[34].ZedPath = "ZedternalReborn.WMPawn_ZedHusk_NoDAR";
		default.Zed_Wave[34].MinWave = 9;
		default.Zed_Wave[34].MaxWave = 999;
		default.Zed_Wave[34].MinGr = 1;
		default.Zed_Wave[34].MaxGr = 2;

		default.Zed_Wave[35].ZedPath = "ZedternalReborn.WMPawn_ZedHusk_Omega";
		default.Zed_Wave[35].MinWave = 13;
		default.Zed_Wave[35].MaxWave = 999;
		default.Zed_Wave[35].MinGr = 1;
		default.Zed_Wave[35].MaxGr = 2;

		default.Zed_Wave[36].ZedPath = "ZedternalReborn.WMPawn_ZedHusk_Omega";
		default.Zed_Wave[36].MinWave = 17;
		default.Zed_Wave[36].MaxWave = 999;
		default.Zed_Wave[36].MinGr = 1;
		default.Zed_Wave[36].MaxGr = 4;

		// Siren

		default.Zed_Wave[37].ZedPath = "KFGameContent.KFPawn_ZedSiren";
		default.Zed_Wave[37].MinWave = 3;
		default.Zed_Wave[37].MaxWave = 23;
		default.Zed_Wave[37].MinGr = 1;
		default.Zed_Wave[37].MaxGr = 1;

		default.Zed_Wave[38].ZedPath = "KFGameContent.KFPawn_ZedSiren";
		default.Zed_Wave[38].MinWave = 7;
		default.Zed_Wave[38].MaxWave = 999;
		default.Zed_Wave[38].MinGr = 1;
		default.Zed_Wave[38].MaxGr = 2;

		default.Zed_Wave[39].ZedPath = "ZedternalReborn.WMPawn_ZedSiren_Omega";
		default.Zed_Wave[39].MinWave = 23;
		default.Zed_Wave[39].MaxWave = 999;
		default.Zed_Wave[39].MinGr = 1;
		default.Zed_Wave[39].MaxGr = 2;

		// Fleshpound Mini

		default.Zed_Wave[40].ZedPath = "KFGameContent.KFPawn_ZedFleshpoundMini";
		default.Zed_Wave[40].MinWave = 4;
		default.Zed_Wave[40].MaxWave = 10;
		default.Zed_Wave[40].MinGr = 1;
		default.Zed_Wave[40].MaxGr = 1;

		default.Zed_Wave[41].ZedPath = "KFGameContent.KFPawn_ZedFleshpoundMini";
		default.Zed_Wave[41].MinWave = 9;
		default.Zed_Wave[41].MaxWave = 15;
		default.Zed_Wave[41].MinGr = 1;
		default.Zed_Wave[41].MaxGr = 1;

		// Scrake

		default.Zed_Wave[42].ZedPath = "KFGameContent.KFPawn_ZedScrake";
		default.Zed_Wave[42].MinWave = 2;
		default.Zed_Wave[42].MaxWave = 5;
		default.Zed_Wave[42].MinGr = 1;
		default.Zed_Wave[42].MaxGr = 1;

		default.Zed_Wave[43].ZedPath = "KFGameContent.KFPawn_ZedScrake";
		default.Zed_Wave[43].MinWave = 5;
		default.Zed_Wave[43].MaxWave = 999;
		default.Zed_Wave[43].MinGr = 1;
		default.Zed_Wave[43].MaxGr = 2;

		default.Zed_Wave[44].ZedPath = "KFGameContent.KFPawn_ZedScrake";
		default.Zed_Wave[44].MinWave = 8;
		default.Zed_Wave[44].MaxWave = 15;
		default.Zed_Wave[44].MinGr = 1;
		default.Zed_Wave[44].MaxGr = 3;

		default.Zed_Wave[45].ZedPath = "KFGameContent.KFPawn_ZedScrake";
		default.Zed_Wave[45].MinWave = 13;
		default.Zed_Wave[45].MaxWave = 999;
		default.Zed_Wave[45].MinGr = 1;
		default.Zed_Wave[45].MaxGr = 4;

		default.Zed_Wave[46].ZedPath = "ZedternalReborn.WMPawn_ZedScrake_Omega";
		default.Zed_Wave[46].MinWave = 13;
		default.Zed_Wave[46].MaxWave = 30;
		default.Zed_Wave[46].MinGr = 1;
		default.Zed_Wave[46].MaxGr = 1;

		default.Zed_Wave[47].ZedPath = "ZedternalReborn.WMPawn_ZedScrake_Omega";
		default.Zed_Wave[47].MinWave = 17;
		default.Zed_Wave[47].MaxWave = 999;
		default.Zed_Wave[47].MinGr = 1;
		default.Zed_Wave[47].MaxGr = 2;

		default.Zed_Wave[48].ZedPath = "ZedternalReborn.WMPawn_ZedScrake_Omega";
		default.Zed_Wave[48].MinWave = 21;
		default.Zed_Wave[48].MaxWave = 999;
		default.Zed_Wave[48].MinGr = 1;
		default.Zed_Wave[48].MaxGr = 4;

		default.Zed_Wave[49].ZedPath = "ZedternalReborn.WMPawn_ZedScrake_Omega";
		default.Zed_Wave[49].MinWave = 25;
		default.Zed_Wave[49].MaxWave = 999;
		default.Zed_Wave[49].MinGr = 2;
		default.Zed_Wave[49].MaxGr = 6;

		// Fleshpound

		default.Zed_Wave[50].ZedPath = "KFGameContent.KFPawn_ZedFleshpound";
		default.Zed_Wave[50].MinWave = 5;
		default.Zed_Wave[50].MaxWave = 999;
		default.Zed_Wave[50].MinGr = 1;
		default.Zed_Wave[50].MaxGr = 1;

		default.Zed_Wave[51].ZedPath = "KFGameContent.KFPawn_ZedFleshpound";
		default.Zed_Wave[51].MinWave = 8;
		default.Zed_Wave[51].MaxWave = 999;
		default.Zed_Wave[51].MinGr = 1;
		default.Zed_Wave[51].MaxGr = 2;

		default.Zed_Wave[52].ZedPath = "ZedternalReborn.WMPawn_ZedFleshpound_Omega";
		default.Zed_Wave[52].MinWave = 15;
		default.Zed_Wave[52].MaxWave = 27;
		default.Zed_Wave[52].MinGr = 1;
		default.Zed_Wave[52].MaxGr = 1;

		default.Zed_Wave[53].ZedPath = "ZedternalReborn.WMPawn_ZedFleshpound_Omega";
		default.Zed_Wave[53].MinWave = 19;
		default.Zed_Wave[53].MaxWave = 999;
		default.Zed_Wave[53].MinGr = 1;
		default.Zed_Wave[53].MaxGr = 2;

		default.Zed_Wave[54].ZedPath = "ZedternalReborn.WMPawn_ZedFleshpound_Omega";
		default.Zed_Wave[54].MinWave = 22;
		default.Zed_Wave[54].MaxWave = 999;
		default.Zed_Wave[54].MinGr = 2;
		default.Zed_Wave[54].MaxGr = 3;

		// Additional spawns

		default.Zed_Wave[55].ZedPath = "KFGameContent.KFPawn_ZedDAR_Rocket";
		default.Zed_Wave[55].MinWave = 9;
		default.Zed_Wave[55].MaxWave = 999;
		default.Zed_Wave[55].MinGr = 1;
		default.Zed_Wave[55].MaxGr = 1;

		default.Zed_Wave[56].ZedPath = "KFGameContent.KFPawn_ZedBloatKingSubspawn";
		default.Zed_Wave[56].MinWave = 12;
		default.Zed_Wave[56].MaxWave = 999;
		default.Zed_Wave[56].MinGr = 1;
		default.Zed_Wave[56].MaxGr = 1;

		// Bosses

		default.Zed_Wave[57].ZedPath = "ZedternalReborn.WMPawn_ZedPatriarch";
		default.Zed_Wave[57].MinWave = 17;
		default.Zed_Wave[57].MaxWave = 999;
		default.Zed_Wave[57].MinGr = 1;
		default.Zed_Wave[57].MaxGr = 1;

		default.Zed_Wave[58].ZedPath = "ZedternalReborn.WMPawn_ZedFleshpoundKing";
		default.Zed_Wave[58].MinWave = 21;
		default.Zed_Wave[58].MaxWave = 999;
		default.Zed_Wave[58].MinGr = 1;
		default.Zed_Wave[58].MaxGr = 1;

		default.Zed_Wave[59].ZedPath = "ZedternalReborn.WMPawn_ZedFleshpoundKing";
		default.Zed_Wave[59].MinWave = 25;
		default.Zed_Wave[59].MaxWave = 999;
		default.Zed_Wave[59].MinGr = 1;
		default.Zed_Wave[59].MaxGr = 1;

		default.Zed_Wave[60].ZedPath = "ZedternalReborn.WMPawn_ZedPatriarch";
		default.Zed_Wave[60].MinWave = 29;
		default.Zed_Wave[60].MaxWave = 999;
		default.Zed_Wave[60].MinGr = 1;
		default.Zed_Wave[60].MaxGr = 1;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local int i, temp;

	for (i = 0; i < default.Zed_Wave.Length; ++i)
	{
		if (default.Zed_Wave[i].MinWave < 0)
		{
			LogBadConfigMessage("Zed_Wave - Line" @ string(i + 1) @ "- MinWave",
				string(default.Zed_Wave[i].MinWave),
				"0", "wave 0", "value >= 0");
			default.Zed_Wave[i].MinWave = 0;
		}

		if (default.Zed_Wave[i].MaxWave < 0)
		{
			LogBadConfigMessage("Zed_Wave - Line" @ string(i + 1) @ "- MaxWave",
				string(default.Zed_Wave[i].MaxWave),
				"0", "wave 0", "value >= 0");
			default.Zed_Wave[i].MaxWave = 0;
		}

		if (default.Zed_Wave[i].MinWave > default.Zed_Wave[i].MaxWave)
		{
			LogBadFlipConfigMessage("Zed_Wave - Line" @ string(i + 1), "MinWave", "MaxWave");
			temp = default.Zed_Wave[i].MinWave;
			default.Zed_Wave[i].MinWave = default.Zed_Wave[i].MaxWave;
			default.Zed_Wave[i].MaxWave = temp;
		}

		if (default.Zed_Wave[i].MinGr < 0)
		{
			LogBadConfigMessage("Zed_Wave - Line" @ string(i + 1) @ "- MinGr",
				string(default.Zed_Wave[i].MinGr),
				"0", "0 zeds, no zeds spawn", "8 >= value >= 0");
			default.Zed_Wave[i].MinGr = 0;
		}

		if (default.Zed_Wave[i].MinGr > 8)
		{
			LogBadConfigMessage("Zed_Wave - Line" @ string(i + 1) @ "- MinGr",
				string(default.Zed_Wave[i].MinGr),
				"8", "8 zeds, max zed group spawn size", "8 >= value >= 0");
			default.Zed_Wave[i].MinGr = 8;
		}

		if (default.Zed_Wave[i].MaxGr < 0)
		{
			LogBadConfigMessage("Zed_Wave - Line" @ string(i + 1) @ "- MaxGr",
				string(default.Zed_Wave[i].MaxGr),
				"0", "0 zeds, no zeds spawn", "8 >= value >= 0");
			default.Zed_Wave[i].MaxGr = 0;
		}

		if (default.Zed_Wave[i].MaxGr > 8)
		{
			LogBadConfigMessage("Zed_Wave - Line" @ string(i + 1) @ "- MaxGr",
				string(default.Zed_Wave[i].MaxGr),
				"8", "8 zeds, max zed group spawn size", "8 >= value >= 0");
			default.Zed_Wave[i].MaxGr = 8;
		}

		if (default.Zed_Wave[i].MinGr > default.Zed_Wave[i].MaxGr)
		{
			LogBadFlipConfigMessage("Zed_Wave - Line" @ string(i + 1), "MinGr", "MaxGr");
			temp = default.Zed_Wave[i].MinGr;
			default.Zed_Wave[i].MinGr = default.Zed_Wave[i].MaxGr;
			default.Zed_Wave[i].MaxGr = temp;
		}
	}
}

static function LoadConfigObjects(out array<S_ZedWave> ValidZedWaves, out array< class<KFPawn_Monster> > ZedObjects)
{
	local int i, Ins;
	local class<KFPawn_Monster> Obj;

	ValidZedWaves.Length = 0;
	ZedObjects.Length = 0;

	for (i = 0; i < default.Zed_Wave.Length; ++i)
	{
		Obj = class<KFPawn_Monster>(DynamicLoadObject(default.Zed_Wave[i].ZedPath, class'Class', True));
		if (Obj == None)
		{
			LogBadLoadObjectConfigMessage("Zed_Wave", i + 1, default.Zed_Wave[i].ZedPath);
		}
		else
		{
			ValidZedWaves.AddItem(default.Zed_Wave[i]);

			if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(ZedObjects, PathName(Obj), Ins))
				ZedObjects.InsertItem(Ins, Obj);
		}
	}
}

defaultproperties
{
	Name="Default__Config_Zed"
}
