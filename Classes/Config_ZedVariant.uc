class Config_ZedVariant extends Config_Common
	config(ZedternalReborn_ZedWaves);

var config int MODEVERSION;

struct S_ZedVariant
{
	var string ZedPath, VariantPath;
	var float Probability;
	var int MinDiff, MaxDiff;
};
var config array<S_ZedVariant> Zed_ZedVariant;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		/////////////////////////////
		/////// Variant List ////////
		/////////////////////////////

		default.Zed_ZedVariant.Length = 15;

		//Crawler

		default.Zed_ZedVariant[0].ZedPath = "ZedternalReborn.WMPawn_ZedCrawler_NoElite";
		default.Zed_ZedVariant[0].VariantPath = "KFGameContent.KFPawn_ZedCrawlerKing";
		default.Zed_ZedVariant[0].Probability = 0.05f;
		default.Zed_ZedVariant[0].MinDiff = 0;
		default.Zed_ZedVariant[0].MaxDiff = 0;

		default.Zed_ZedVariant[1].ZedPath = "ZedternalReborn.WMPawn_ZedCrawler_NoElite";
		default.Zed_ZedVariant[1].VariantPath = "KFGameContent.KFPawn_ZedCrawlerKing";
		default.Zed_ZedVariant[1].Probability = 0.1f;
		default.Zed_ZedVariant[1].MinDiff = 1;
		default.Zed_ZedVariant[1].MaxDiff = 1;

		default.Zed_ZedVariant[2].ZedPath = "ZedternalReborn.WMPawn_ZedCrawler_NoElite";
		default.Zed_ZedVariant[2].VariantPath = "KFGameContent.KFPawn_ZedCrawlerKing";
		default.Zed_ZedVariant[2].Probability = 0.2f;
		default.Zed_ZedVariant[2].MinDiff = 2;
		default.Zed_ZedVariant[2].MaxDiff = 4;

		// Alpha clot

		default.Zed_ZedVariant[3].ZedPath = "ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot";
		default.Zed_ZedVariant[3].VariantPath = "KFGameContent.KFPawn_ZedClot_AlphaKing";
		default.Zed_ZedVariant[3].Probability = 0.1f;
		default.Zed_ZedVariant[3].MinDiff = 0;
		default.Zed_ZedVariant[3].MaxDiff = 0;

		default.Zed_ZedVariant[4].ZedPath = "ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot";
		default.Zed_ZedVariant[4].VariantPath = "KFGameContent.KFPawn_ZedClot_AlphaKing";
		default.Zed_ZedVariant[4].Probability = 0.2f;
		default.Zed_ZedVariant[4].MinDiff = 1;
		default.Zed_ZedVariant[4].MaxDiff = 1;

		default.Zed_ZedVariant[5].ZedPath = "ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot";
		default.Zed_ZedVariant[5].VariantPath = "KFGameContent.KFPawn_ZedClot_AlphaKing";
		default.Zed_ZedVariant[5].Probability = 0.3f;
		default.Zed_ZedVariant[5].MinDiff = 2;
		default.Zed_ZedVariant[5].MaxDiff = 4;

		// Gorefast

		default.Zed_ZedVariant[6].ZedPath = "ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade";
		default.Zed_ZedVariant[6].VariantPath = "KFGameContent.KFPawn_ZedGorefastDualBlade";
		default.Zed_ZedVariant[6].Probability = 0.1f;
		default.Zed_ZedVariant[6].MinDiff = 0;
		default.Zed_ZedVariant[6].MaxDiff = 0;

		default.Zed_ZedVariant[7].ZedPath = "ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade";
		default.Zed_ZedVariant[7].VariantPath = "KFGameContent.KFPawn_ZedGorefastDualBlade";
		default.Zed_ZedVariant[7].Probability = 0.25f;
		default.Zed_ZedVariant[7].MinDiff = 1;
		default.Zed_ZedVariant[7].MaxDiff = 1;

		default.Zed_ZedVariant[8].ZedPath = "ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade";
		default.Zed_ZedVariant[8].VariantPath = "KFGameContent.KFPawn_ZedGorefastDualBlade";
		default.Zed_ZedVariant[8].Probability = 0.35f;
		default.Zed_ZedVariant[8].MinDiff = 2;
		default.Zed_ZedVariant[8].MaxDiff = 4;

		// Scrake

		default.Zed_ZedVariant[9].ZedPath = "KFGameContent.KFPawn_ZedScrake";
		default.Zed_ZedVariant[9].VariantPath = "ZedternalReborn.WMPawn_ZedScrake_Tiny";
		default.Zed_ZedVariant[9].Probability = 0.01f;
		default.Zed_ZedVariant[9].MinDiff = 0;
		default.Zed_ZedVariant[9].MaxDiff = 4;

		// DAR

		default.Zed_ZedVariant[10].ZedPath = "KFGameContent.KFPawn_ZedDAR_Rocket";
		default.Zed_ZedVariant[10].VariantPath = "KFGameContent.KFPawn_ZedDAR_EMP";
		default.Zed_ZedVariant[10].Probability = 0.33f;
		default.Zed_ZedVariant[10].MinDiff = 0;
		default.Zed_ZedVariant[10].MaxDiff = 4;

		default.Zed_ZedVariant[11].ZedPath = "KFGameContent.KFPawn_ZedDAR_Rocket";
		default.Zed_ZedVariant[11].VariantPath = "KFGameContent.KFPawn_ZedDAR_Laser";
		default.Zed_ZedVariant[11].Probability = 0.33f;
		default.Zed_ZedVariant[11].MinDiff = 0;
		default.Zed_ZedVariant[11].MaxDiff = 4;

		// Bosses

		default.Zed_ZedVariant[12].ZedPath = "ZedternalReborn.WMPawn_ZedPatriarch";
		default.Zed_ZedVariant[12].VariantPath = "ZedternalReborn.WMPawn_ZedHans";
		default.Zed_ZedVariant[12].Probability = 0.33f;
		default.Zed_ZedVariant[12].MinDiff = 0;
		default.Zed_ZedVariant[12].MaxDiff = 4;

		default.Zed_ZedVariant[13].ZedPath = "ZedternalReborn.WMPawn_ZedPatriarch";
		default.Zed_ZedVariant[13].VariantPath = "ZedternalReborn.WMPawn_ZedMatriarch";
		default.Zed_ZedVariant[13].Probability = 0.33f;
		default.Zed_ZedVariant[13].MinDiff = 0;
		default.Zed_ZedVariant[13].MaxDiff = 4;

		default.Zed_ZedVariant[14].ZedPath = "ZedternalReborn.WMPawn_ZedFleshpoundKing";
		default.Zed_ZedVariant[14].VariantPath = "ZedternalReborn.WMPawn_ZedBloatKing";
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
				"0", "normal difficulty", "4 >= value >= 0");
			default.Zed_ZedVariant[i].MaxDiff = 0;
		}

		if (default.Zed_ZedVariant[i].MaxDiff > 4)
		{
			LogBadConfigMessage("Zed_ZedVariant - Line" @ string(i + 1) @ "- MaxDiff",
				string(default.Zed_ZedVariant[i].MaxDiff),
				"4", "custom difficulty", "4 >= value >= 0");
			default.Zed_ZedVariant[i].MaxDiff = 4;
		}

		if (default.Zed_ZedVariant[i].MinDiff > default.Zed_ZedVariant[i].MaxDiff)
		{
			LogBadFlipConfigMessage("Zed_ZedVariant - Line" @ string(i + 1), "MinDiff", "MaxDiff");
			temp = default.Zed_ZedVariant[i].MinDiff;
			default.Zed_ZedVariant[i].MinDiff = default.Zed_ZedVariant[i].MaxDiff;
			default.Zed_ZedVariant[i].MaxDiff = temp;
		}
	}
}

static function LoadConfigObjects(out array<S_ZedVariant> ValidZedVariants, out array< class<KFPawn_Monster> > ZedObjects)
{
	local int i, Ins;
	local class<KFPawn_Monster> Obj, VarObj;

	ValidZedVariants.Length = 0;
	ZedObjects.Length = 0;

	for (i = 0; i < default.Zed_ZedVariant.Length; ++i)
	{
		Obj = class<KFPawn_Monster>(DynamicLoadObject(default.Zed_ZedVariant[i].ZedPath, class'Class', True));
		if (Obj == None)
		{
			LogBadLoadObjectConfigMessage("Zed_ZedVariant - ZedPath", i + 1, default.Zed_ZedVariant[i].ZedPath);
			continue;
		}

		VarObj = class<KFPawn_Monster>(DynamicLoadObject(default.Zed_ZedVariant[i].VariantPath, class'Class', True));
		if (VarObj == None)
		{
			LogBadLoadObjectConfigMessage("Zed_ZedVariant - VariantPath", i + 1, default.Zed_ZedVariant[i].VariantPath);
			continue;
		}

		ValidZedVariants.AddItem(default.Zed_ZedVariant[i]);

		if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(ZedObjects, PathName(Obj), Ins))
			ZedObjects.InsertItem(Ins, Obj);

		if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(ZedObjects, PathName(VarObj), Ins))
			ZedObjects.InsertItem(Ins, VarObj);
	}
}

defaultproperties
{
	Name="Default__Config_ZedVariant"
}
