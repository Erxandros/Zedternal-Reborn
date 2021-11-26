class Config_DifficultyGroup extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

var config bool ZedGroup_bEnableGroupList;

struct S_ZedDiffGroup
{
	var string GroupName;
	var array<string> ZedPaths;
};

var config array<S_ZedDiffGroup> ZedGroup_GroupList;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedGroup_bEnableGroupList = False;

		default.ZedGroup_GroupList.Length = 1;

		default.ZedGroup_GroupList[0].GroupName = "ExampleGroup";
		default.ZedGroup_GroupList[0].ZedPaths.Length = 3;
		default.ZedGroup_GroupList[0].ZedPaths[0] = "KFGameContent.KFPawn_ZedFleshpoundMini";
		default.ZedGroup_GroupList[0].ZedPaths[1] = "KFGameContent.KFPawn_ZedScrake";
		default.ZedGroup_GroupList[0].ZedPaths[2] = "KFGameContent.KFPawn_ZedBloatKingSubspawn";
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local int i;

	for (i = 0; i < default.ZedGroup_GroupList.Length; ++i)
	{
		if (default.ZedGroup_GroupList[i].ZedPaths.Length == 0)
		{
			LogEmptyArrayConfigMessage("For group name" @default.ZedGroup_GroupList[i].GroupName $", ZedGroup_GroupList.ZedPaths");
			default.ZedGroup_GroupList.Remove(i, 1);
			--i;
		}
	}
}

static function LoadConfigObjects(out array<string> ValidZedDiffGroupNames, out array<int> ValidZedDiffGroupID,
	out array< class<KFPawn_Monster> > ZedObjects)
{
	local int i, x, Ins;
	local class<KFPawn_Monster> Obj;

	ValidZedDiffGroupNames.Length = 0;
	ValidZedDiffGroupID.Length = 0;
	ZedObjects.Length = 0;

	if (default.ZedGroup_bEnableGroupList)
	{
		for (i = 0; i < default.ZedGroup_GroupList.Length; ++i)
		{
			ValidZedDiffGroupNames.AddItem(default.ZedGroup_GroupList[i].GroupName);

			for (x = 0; x < default.ZedGroup_GroupList[i].ZedPaths.Length; ++x)
			{
				Obj = class<KFPawn_Monster>(DynamicLoadObject(default.ZedGroup_GroupList[i].ZedPaths[x], class'Class', True));
				if (Obj == None)
				{
					LogBadLoadObjectConfigMessage("ZedGroup_GroupList", i + 1, default.ZedGroup_GroupList[i].ZedPaths[x]);
				}
				else
				{
					if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(ZedObjects, PathName(Obj), Ins))
					{
						ZedObjects.InsertItem(Ins, Obj);
						ValidZedDiffGroupID.InsertItem(Ins, i);
					}
				}
			}
		}
	}
}

defaultproperties
{
	Name="Default__Config_DifficultyGroup"
}
