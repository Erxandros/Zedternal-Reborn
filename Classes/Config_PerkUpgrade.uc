class Config_PerkUpgrade extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

var config array<string> PerkUpgrade_Upgrade;
var config array<string> PerkUpgrade_StaticUpgrade;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.PerkUpgrade_Upgrade[0] = "ZedternalReborn.WMUpgrade_Perk_Berserker";
		default.PerkUpgrade_Upgrade[1] = "ZedternalReborn.WMUpgrade_Perk_Commando";
		default.PerkUpgrade_Upgrade[2] = "ZedternalReborn.WMUpgrade_Perk_Demolitionist";
		default.PerkUpgrade_Upgrade[3] = "ZedternalReborn.WMUpgrade_Perk_FieldMedic";
		default.PerkUpgrade_Upgrade[4] = "ZedternalReborn.WMUpgrade_Perk_SWAT";
		default.PerkUpgrade_Upgrade[5] = "ZedternalReborn.WMUpgrade_Perk_Gunslinger";
		default.PerkUpgrade_Upgrade[6] = "ZedternalReborn.WMUpgrade_Perk_Sharpshooter";
		default.PerkUpgrade_Upgrade[7] = "ZedternalReborn.WMUpgrade_Perk_Support";
		default.PerkUpgrade_Upgrade[8] = "ZedternalReborn.WMUpgrade_Perk_FireBug";
		default.PerkUpgrade_Upgrade[9] = "ZedternalReborn.WMUpgrade_Perk_Survivalist";
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function LoadConfigObjects(out array<string> ValidUpgrades, out array< class<WMUpgrade_Perk> > UpgradeObjects)
{
	local int i;
	local class<WMUpgrade_Perk> Obj;

	ValidUpgrades.Length = 0;
	UpgradeObjects.Length = 0;

	for (i = 0; i < default.PerkUpgrade_Upgrade.Length; ++i)
	{
		Obj = class<WMUpgrade_Perk>(DynamicLoadObject(default.PerkUpgrade_Upgrade[i], class'Class', True));
		if (Obj == None)
		{
			`log("ZR Config: Perk upgrade" @ default.PerkUpgrade_Upgrade[i] @ "failed to load. Skip adding the Perk upgrade to the game."
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
