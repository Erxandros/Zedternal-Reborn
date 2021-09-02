class Config_PerkUpgrade extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

struct S_PerkUpgrade
{
	var string PerkPath;
	var bool bIsStatic;
};

var config array<S_PerkUpgrade> PerkUpgrade_Upgrade;

static function UpdateConfig()
{
	local int i;

	if (default.MODEVERSION < 1)
	{
		default.PerkUpgrade_Upgrade.Length = 10;
		default.PerkUpgrade_Upgrade[0].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Berserker";
		default.PerkUpgrade_Upgrade[1].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Commando";
		default.PerkUpgrade_Upgrade[2].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Demolitionist";
		default.PerkUpgrade_Upgrade[3].PerkPath = "ZedternalReborn.WMUpgrade_Perk_FieldMedic";
		default.PerkUpgrade_Upgrade[4].PerkPath = "ZedternalReborn.WMUpgrade_Perk_SWAT";
		default.PerkUpgrade_Upgrade[5].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Gunslinger";
		default.PerkUpgrade_Upgrade[6].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Sharpshooter";
		default.PerkUpgrade_Upgrade[7].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Support";
		default.PerkUpgrade_Upgrade[8].PerkPath = "ZedternalReborn.WMUpgrade_Perk_FireBug";
		default.PerkUpgrade_Upgrade[9].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Survivalist";

		for (i = 0; i <= 9; ++i)
		{
			default.PerkUpgrade_Upgrade[i].bIsStatic = False;
		}
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function LoadConfigObjects(out array<S_PerkUpgrade> ValidUpgrades, out array< class<WMUpgrade_Perk> > UpgradeObjects)
{
	local int i;
	local class<WMUpgrade_Perk> Obj;

	ValidUpgrades.Length = 0;
	UpgradeObjects.Length = 0;

	for (i = 0; i < default.PerkUpgrade_Upgrade.Length; ++i)
	{
		Obj = class<WMUpgrade_Perk>(DynamicLoadObject(default.PerkUpgrade_Upgrade[i].PerkPath, class'Class', True));
		if (Obj == None)
		{
			`log("ZR Config: Perk upgrade" @ default.PerkUpgrade_Upgrade[i].PerkPath @ "failed to load. Skip adding the Perk upgrade to the game."
				@"Please double check the name in the config and make sure the correct mod resources are installed.");
		}
		else
		{
			ValidUpgrades.AddItem(default.PerkUpgrade_Upgrade[i]);
			UpgradeObjects.AddItem(Obj);
		}
	}
}

defaultproperties
{
	Name="Default__Config_PerkUpgrade"
}
