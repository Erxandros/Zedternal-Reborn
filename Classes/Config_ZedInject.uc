class Config_ZedInject extends Config_Common
	config(ZedternalReborn_ZedWaves);

var config int MODEVERSION;

var config bool Zed_bEnableWaveGroupInjection;

struct S_ZedSpawnGroup
{
	var int Wave;
	var string ZedPath;
	var string Position;
	var int Count;
	var float Probability;
	var int MinDiff, MaxDiff;

	structdefaultproperties
	{
		Position = "END";
		Probability = 1.0f;
	}
};
var config array<S_ZedSpawnGroup> Zed_WaveGroupInject;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Zed_bEnableWaveGroupInjection = False;

		default.Zed_WaveGroupInject.Length = 1;

		default.Zed_WaveGroupInject[0].Wave = 10;
		default.Zed_WaveGroupInject[0].ZedPath = "ZedternalReborn.WMPawn_ZedCrawler_Ultra";
		default.Zed_WaveGroupInject[0].Position = "END";
		default.Zed_WaveGroupInject[0].Count = 3;
		default.Zed_WaveGroupInject[0].Probability = 1.0f;
		default.Zed_WaveGroupInject[0].MinDiff = 0;
		default.Zed_WaveGroupInject[0].MaxDiff = 4;
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

	for (i = 0; i < default.Zed_WaveGroupInject.Length; ++i)
	{
		if (default.Zed_WaveGroupInject[i].Wave < 0)
		{
			LogBadConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1) @ "- Wave",
				string(default.Zed_WaveGroupInject[i].Wave),
				"0", "wave 0, never activated", "value >= 0");
			default.Zed_WaveGroupInject[i].Wave = 0;
		}

		if (Caps(default.Zed_WaveGroupInject[i].Position) != "BEG" && Caps(default.Zed_WaveGroupInject[i].Position) != "MID"
			&& Caps(default.Zed_WaveGroupInject[i].Position) != "END")
		{
			LogBadConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1) @ "- Position",
				Caps(default.Zed_WaveGroupInject[i].Position),
				"END", "END, add zeds to end of wave", "value == BEG or value == MID or value == END");
			default.Zed_WaveGroupInject[i].Position = "END";
		}

		if (default.Zed_WaveGroupInject[i].Count < 0)
		{
			LogBadConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1) @ "- Count",
				string(default.Zed_WaveGroupInject[i].Count),
				"0", "0 zeds, disabled", "8 >= value >= 0");
			default.Zed_WaveGroupInject[i].Count = 0;
		}

		if (default.Zed_WaveGroupInject[i].Count > 8)
		{
			LogBadConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1) @ "- Count",
				string(default.Zed_WaveGroupInject[i].Count),
				"8", "8 zeds, max zed group spawn size", "8 >= value >= 0");
			default.Zed_WaveGroupInject[i].Count = 8;
		}

		if (default.Zed_WaveGroupInject[i].Probability < 0.0f)
		{
			LogBadConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1) @ "- Probability",
				string(default.Zed_WaveGroupInject[i].Probability),
				"0.0", "0%, never selected", "1.0 >= value >= 0.0");
			default.Zed_WaveGroupInject[i].Probability = 0.0f;
		}

		if (default.Zed_WaveGroupInject[i].Probability > 1.0f)
		{
			LogBadConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1) @ "- Probability",
				string(default.Zed_WaveGroupInject[i].Probability),
				"1.0", "100%, always selected", "1.0 >= value >= 0.0");
			default.Zed_WaveGroupInject[i].Probability = 1.0f;
		}

		if (default.Zed_WaveGroupInject[i].MinDiff < 0)
		{
			LogBadConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1) @ "- MinDiff",
				string(default.Zed_WaveGroupInject[i].MinDiff),
				"0", "normal difficulty", "4 >= value >= 0");
			default.Zed_WaveGroupInject[i].MinDiff = 0;
		}

		if (default.Zed_WaveGroupInject[i].MinDiff > 4)
		{
			LogBadConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1) @ "- MinDiff",
				string(default.Zed_WaveGroupInject[i].MinDiff),
				"4", "custom difficulty", "4 >= value >= 0");
			default.Zed_WaveGroupInject[i].MinDiff = 4;
		}

		if (default.Zed_WaveGroupInject[i].MaxDiff < 0)
		{
			LogBadConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1) @ "- MaxDiff",
				string(default.Zed_WaveGroupInject[i].MaxDiff),
				"0", "normal difficulty", "4 >= value >= 0");
			default.Zed_WaveGroupInject[i].MaxDiff = 0;
		}

		if (default.Zed_WaveGroupInject[i].MaxDiff > 4)
		{
			LogBadConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1) @ "- MaxDiff",
				string(default.Zed_WaveGroupInject[i].MaxDiff),
				"4", "custom difficulty", "4 >= value >= 0");
			default.Zed_WaveGroupInject[i].MaxDiff = 4;
		}

		if (default.Zed_WaveGroupInject[i].MinDiff > default.Zed_WaveGroupInject[i].MaxDiff)
		{
			LogBadFlipConfigMessage("Zed_WaveGroupInject - Line" @ string(i + 1), "MinDiff", "MaxDiff");
			temp = default.Zed_WaveGroupInject[i].MinDiff;
			default.Zed_WaveGroupInject[i].MinDiff = default.Zed_WaveGroupInject[i].MaxDiff;
			default.Zed_WaveGroupInject[i].MaxDiff = temp;
		}
	}
}

static function LoadConfigObjects(out array<S_ZedSpawnGroup> ValidZedGroupInjects, out array< class<KFPawn_Monster> > ZedObjects)
{
	local int i, Ins;
	local class<KFPawn_Monster> Obj;

	ValidZedGroupInjects.Length = 0;
	ZedObjects.Length = 0;

	for (i = 0; i < default.Zed_WaveGroupInject.Length; ++i)
	{
		Obj = class<KFPawn_Monster>(DynamicLoadObject(default.Zed_WaveGroupInject[i].ZedPath, class'Class', True));
		if (Obj == None)
		{
			LogBadLoadObjectConfigMessage("Zed_WaveGroupInject", i + 1, default.Zed_WaveGroupInject[i].ZedPath);
		}
		else
		{
			ValidZedGroupInjects.AddItem(default.Zed_WaveGroupInject[i]);

			if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(ZedObjects, PathName(Obj), Ins))
				ZedObjects.InsertItem(Ins, Obj);
		}
	}
}

defaultproperties
{
	Name="Default__Config_ZedInject"
}
