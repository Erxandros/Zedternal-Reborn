class WMGameInfo_ConfigInit extends Object;

//Events
var array<S_SpecialWave> ValidSpecialWaves;
var array< class<WMSpecialWave> > LoadedSpecialWaveObjects;

var array<S_SpecialWaveOverride> ValidSpecialWaveOverrides;
var array< class<WMSpecialWave> > LoadedSWOverrideObjects;

//Upgrades
var array<S_PerkUpgrade> ValidPerkUpgrades;
var array< class<WMUpgrade_Perk> > LoadedPerkUpgObjects;

var array<S_SkillUpgrade> ValidSkillUpgrades;
var array< class<WMUpgrade_Skill> > LoadedSkillUpgObjects;

var array<S_WeaponUpgrade> ValidWeaponUpgrades;
var array< class<WMUpgrade_Weapon> > LoadedWeaponUpgObjects;

var array<S_EquipmentUpgrade> ValidEquipmentUpgrades;
var array< class<WMUpgrade_Equipment> > LoadedEquipmentUpgObjects;

function InitializeConfigData()
{
	class'ZedternalReborn.Config_SpecialWave'.static.LoadConfigObjects(ValidSpecialWaves, LoadedSpecialWaveObjects);
	class'ZedternalReborn.Config_SpecialWaveOverride'.static.LoadConfigObjects(ValidSpecialWaveOverrides, LoadedSWOverrideObjects);
	class'ZedternalReborn.Config_PerkUpgrade'.static.LoadConfigObjects(ValidPerkUpgrades, LoadedPerkUpgObjects);
	class'ZedternalReborn.Config_SkillUpgrade'.static.LoadConfigObjects(ValidSkillUpgrades, LoadedSkillUpgObjects);
	class'ZedternalReborn.Config_WeaponUpgrade'.static.LoadConfigObjects(ValidWeaponUpgrades, LoadedWeaponUpgObjects);
	class'ZedternalReborn.Config_EquipmentUpgrade'.static.LoadConfigObjects(ValidEquipmentUpgrades, LoadedEquipmentUpgObjects);
}

function static int BinarySearch(const out array<object> InArray, string ObjName, out int Low)
{
	local int Mid, High;

	ObjName = Caps(ObjName);
	Low = 0;
	High = InArray.Length - 1;
	while (Low <= High)
	{
		Mid = (Low + High) / 2;
		if (ObjName < Caps(PathName(InArray[Mid])))
			High = Mid - 1;
		else if (ObjName > Caps(PathName(InArray[Mid])))
			Low = Mid + 1;
		else
			return Mid;
	}

	return INDEX_NONE;
}

defaultproperties
{
	Name="Default__WMGameInfo_ConfigInit"
}
