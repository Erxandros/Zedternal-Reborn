class Config_ZedVariant extends Config_Common
	config(ZedternalReborn_ZedWaves);

var config int MODEVERSION;

struct SZedVariant
{
	var class<KFPawn_Monster> ZedClass, VariantClass;
	var float Probability;
	var int MinDiff, MaxDiff;
};
var config array<SZedVariant> Zed_ZedVariant;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		/////////////////////////////
		/////// Variant List ////////
		/////////////////////////////

		default.Zed_ZedVariant.Length = 15;

		//Crawler

		default.Zed_ZedVariant[0].ZedClass = class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
		default.Zed_ZedVariant[0].VariantClass = class'KFGameContent.KFPawn_ZedCrawlerKing';
		default.Zed_ZedVariant[0].Probability = 0.05f;
		default.Zed_ZedVariant[0].MinDiff = 0;
		default.Zed_ZedVariant[0].MaxDiff = 0;

		default.Zed_ZedVariant[1].ZedClass = class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
		default.Zed_ZedVariant[1].VariantClass = class'KFGameContent.KFPawn_ZedCrawlerKing';
		default.Zed_ZedVariant[1].Probability = 0.1f;
		default.Zed_ZedVariant[1].MinDiff = 1;
		default.Zed_ZedVariant[1].MaxDiff = 1;

		default.Zed_ZedVariant[2].ZedClass = class'ZedternalReborn.WMPawn_ZedCrawler_NoElite';
		default.Zed_ZedVariant[2].VariantClass = class'KFGameContent.KFPawn_ZedCrawlerKing';
		default.Zed_ZedVariant[2].Probability = 0.2f;
		default.Zed_ZedVariant[2].MinDiff = 2;
		default.Zed_ZedVariant[2].MaxDiff = 4;

		// Alpha clot

		default.Zed_ZedVariant[3].ZedClass = class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
		default.Zed_ZedVariant[3].VariantClass = class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		default.Zed_ZedVariant[3].Probability = 0.1f;
		default.Zed_ZedVariant[3].MinDiff = 0;
		default.Zed_ZedVariant[3].MaxDiff = 0;

		default.Zed_ZedVariant[4].ZedClass = class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
		default.Zed_ZedVariant[4].VariantClass = class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		default.Zed_ZedVariant[4].Probability = 0.2f;
		default.Zed_ZedVariant[4].MinDiff = 1;
		default.Zed_ZedVariant[4].MaxDiff = 1;

		default.Zed_ZedVariant[5].ZedClass = class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot';
		default.Zed_ZedVariant[5].VariantClass = class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		default.Zed_ZedVariant[5].Probability = 0.3f;
		default.Zed_ZedVariant[5].MinDiff = 2;
		default.Zed_ZedVariant[5].MaxDiff = 4;

		// Gorefast

		default.Zed_ZedVariant[6].ZedClass = class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_ZedVariant[6].VariantClass = class'KFGameContent.KFPawn_ZedGorefastDualBlade';
		default.Zed_ZedVariant[6].Probability = 0.1f;
		default.Zed_ZedVariant[6].MinDiff = 0;
		default.Zed_ZedVariant[6].MaxDiff = 0;

		default.Zed_ZedVariant[7].ZedClass = class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_ZedVariant[7].VariantClass = class'KFGameContent.KFPawn_ZedGorefastDualBlade';
		default.Zed_ZedVariant[7].Probability = 0.25f;
		default.Zed_ZedVariant[7].MinDiff = 1;
		default.Zed_ZedVariant[7].MaxDiff = 1;

		default.Zed_ZedVariant[8].ZedClass = class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade';
		default.Zed_ZedVariant[8].VariantClass = class'KFGameContent.KFPawn_ZedGorefastDualBlade';
		default.Zed_ZedVariant[8].Probability = 0.35f;
		default.Zed_ZedVariant[8].MinDiff = 2;
		default.Zed_ZedVariant[8].MaxDiff = 4;

		// Scrake

		default.Zed_ZedVariant[9].ZedClass = class'KFGameContent.KFPawn_ZedScrake';
		default.Zed_ZedVariant[9].VariantClass = class'ZedternalReborn.WMPawn_ZedScrake_Tiny';
		default.Zed_ZedVariant[9].Probability = 0.01f;
		default.Zed_ZedVariant[9].MinDiff = 0;
		default.Zed_ZedVariant[9].MaxDiff = 4;

		// DAR

		default.Zed_ZedVariant[10].ZedClass = class'KFGameContent.KFPawn_ZedDAR_Rocket';
		default.Zed_ZedVariant[10].VariantClass = class'KFGameContent.KFPawn_ZedDAR_EMP';
		default.Zed_ZedVariant[10].Probability = 0.33f;
		default.Zed_ZedVariant[10].MinDiff = 0;
		default.Zed_ZedVariant[10].MaxDiff = 4;

		default.Zed_ZedVariant[11].ZedClass = class'KFGameContent.KFPawn_ZedDAR_Rocket';
		default.Zed_ZedVariant[11].VariantClass = class'KFGameContent.KFPawn_ZedDAR_Laser';
		default.Zed_ZedVariant[11].Probability = 0.33f;
		default.Zed_ZedVariant[11].MinDiff = 0;
		default.Zed_ZedVariant[11].MaxDiff = 4;

		// Bosses

		default.Zed_ZedVariant[12].ZedClass = class'ZedternalReborn.WMPawn_ZedPatriarch';
		default.Zed_ZedVariant[12].VariantClass = class'ZedternalReborn.WMPawn_ZedHans';
		default.Zed_ZedVariant[12].Probability = 0.33f;
		default.Zed_ZedVariant[12].MinDiff = 0;
		default.Zed_ZedVariant[12].MaxDiff = 4;

		default.Zed_ZedVariant[13].ZedClass = class'ZedternalReborn.WMPawn_ZedPatriarch';
		default.Zed_ZedVariant[13].VariantClass = class'ZedternalReborn.WMPawn_ZedMatriarch';
		default.Zed_ZedVariant[13].Probability = 0.33f;
		default.Zed_ZedVariant[13].MinDiff = 0;
		default.Zed_ZedVariant[13].MaxDiff = 4;

		default.Zed_ZedVariant[14].ZedClass = class'ZedternalReborn.WMPawn_ZedFleshpoundKing';
		default.Zed_ZedVariant[14].VariantClass = class'ZedternalReborn.WMPawn_ZedBloatKing';
		default.Zed_ZedVariant[14].Probability = 0.5f;
		default.Zed_ZedVariant[14].MinDiff = 0;
		default.Zed_ZedVariant[14].MaxDiff = 4;
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

	for (i = 0; i < default.Zed_ZedVariant.Length; ++i)
	{
		if (default.Zed_ZedVariant[i].Probability < 0.0f)
		{
			LogBadConfigMessage("Zed_ZedVariant - Line" @ string(i + 1) @ "- Probability",
				string(default.Zed_ZedVariant[i].Probability),
				"0.0", "0%, never selected", "1.0 >= value >= 0");
			default.Zed_ZedVariant[i].Probability = 0.0f;
		}

		if (default.Zed_ZedVariant[i].Probability > 1.0f)
		{
			LogBadConfigMessage("Zed_ZedVariant - Line" @ string(i + 1) @ "- Probability",
				string(default.Zed_ZedVariant[i].Probability),
				"1.0", "100%, always selected", "1.0 >= value >= 0");
			default.Zed_ZedVariant[i].Probability = 1.0f;
		}

		if (default.Zed_ZedVariant[i].MinDiff < 0)
		{
			LogBadConfigMessage("Zed_ZedVariant - Line" @ string(i + 1) @ "- MinDiff",
				string(default.Zed_ZedVariant[i].MinDiff),
				"0", "normal difficulty", "4 >= value >= 0");
			default.Zed_ZedVariant[i].MinDiff = 0;
		}

		if (default.Zed_ZedVariant[i].MinDiff > 4)
		{
			LogBadConfigMessage("Zed_ZedVariant - Line" @ string(i + 1) @ "- MinDiff",
				string(default.Zed_ZedVariant[i].MinDiff),
				"4", "custom difficulty", "4 >= value >= 0");
			default.Zed_ZedVariant[i].MinDiff = 4;
		}

		if (default.Zed_ZedVariant[i].MaxDiff < 0)
		{
			LogBadConfigMessage("Zed_ZedVariant - Line" @ string(i + 1) @ "- MaxDiff",
				string(default.Zed_ZedVariant[i].MaxDiff),
				"0", "normal difficulty", "4 >= value >= 1");
			default.Zed_ZedVariant[i].MaxDiff = 0;
		}

		if (default.Zed_ZedVariant[i].MaxDiff > 4)
		{
			LogBadConfigMessage("Zed_ZedVariant - Line" @ string(i + 1) @ "- MaxDiff",
				string(default.Zed_ZedVariant[i].MaxDiff),
				"4", "custom difficulty", "4 >= value >= 1");
			default.Zed_ZedVariant[i].MaxDiff = 4;
		}

		if (default.Zed_ZedVariant[i].MinDiff > default.Zed_ZedVariant[i].MaxDiff)
		{
			`log("ZR Config:" @ "Zed_ZedVariant - Line" @ string(i + 1)
				@ "- MinDiff is greater than MaxDiff which is invalid. Flipping the values temporarily.");
			temp = default.Zed_ZedVariant[i].MinDiff;
			default.Zed_ZedVariant[i].MinDiff = default.Zed_ZedVariant[i].MaxDiff;
			default.Zed_ZedVariant[i].MaxDiff = temp;
		}
	}
}

defaultproperties
{
	Name="Default__Config_ZedVariant"
}
