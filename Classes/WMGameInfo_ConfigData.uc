class WMGameInfo_ConfigData extends Object;

//Events
var array<S_SpecialWave> ValidSpecialWaves;
var array< class<WMSpecialWave> > SpecialWaveObjects;

var array<S_SpecialWaveOverride> ValidSpecialWaveOverrides;
var array< class<WMSpecialWave> > SWOverrideObjects;

var array<S_ZedBuff> ValidZedBuffs;
var array< class<WMZedBuff> > ZedBuffObjects;

//Upgrades
var array<S_PerkUpgrade> ValidPerkUpgrades;
var array< class<WMUpgrade_Perk> > PerkUpgObjects;

var array<S_SkillUpgrade> ValidSkillUpgrades;
var array< class<WMUpgrade_Skill> > SkillUpgObjects;

var array<S_WeaponUpgrade> ValidWeaponUpgrades;
var array< class<WMUpgrade_Weapon> > WeaponUpgObjects;

var array<S_EquipmentUpgrade> ValidEquipmentUpgrades;
var array< class<WMUpgrade_Equipment> > EquipmentUpgObjects;

//Weapons
var array< class<KFWeaponDefinition> > CustomWeaponDefObjects;
var array< class<KFWeapon> > CustomWeaponObjects;

var array< class<KFWeaponDefinition> > GrenadeWeaponDefObjects;

var array< class<KFWeaponDefinition> > StartingWeaponDefObjects;
var array< class<KFWeapon> > StartingWeaponObjects;

var array< class<KFWeaponDefinition> > StaticWeaponDefObjects;
var array< class<KFWeapon> > StaticWeaponObjects;

var array<float> VariantProbs;
var array< class<KFWeaponDefinition> > VarBaseWeaponDefObjects;
var array< class<KFWeaponDefinition> > VarRepWeaponDefObjects;
var array< class<KFWeaponDefinition> > VarDualWeaponDefObjects;

function InitializeConfigData()
{
	class'ZedternalReborn.Config_SpecialWave'.static.LoadConfigObjects(ValidSpecialWaves, SpecialWaveObjects);
	class'ZedternalReborn.Config_SpecialWaveOverride'.static.LoadConfigObjects(ValidSpecialWaveOverrides, SWOverrideObjects);
	class'ZedternalReborn.Config_ZedBuff'.static.LoadConfigObjects(ValidZedBuffs, ZedBuffObjects);
	class'ZedternalReborn.Config_PerkUpgrade'.static.LoadConfigObjects(ValidPerkUpgrades, PerkUpgObjects);
	class'ZedternalReborn.Config_SkillUpgrade'.static.LoadConfigObjects(ValidSkillUpgrades, SkillUpgObjects);
	class'ZedternalReborn.Config_WeaponUpgrade'.static.LoadConfigObjects(ValidWeaponUpgrades, WeaponUpgObjects);
	class'ZedternalReborn.Config_EquipmentUpgrade'.static.LoadConfigObjects(ValidEquipmentUpgrades, EquipmentUpgObjects);
	class'ZedternalReborn.Config_WeaponCustom'.static.LoadConfigObjects(CustomWeaponDefObjects, CustomWeaponObjects);
	class'ZedternalReborn.Config_WeaponGrenade'.static.LoadConfigObjects(GrenadeWeaponDefObjects);
	class'ZedternalReborn.Config_WeaponStarting'.static.LoadConfigObjects(StartingWeaponDefObjects, StartingWeaponObjects);
	class'ZedternalReborn.Config_WeaponStatic'.static.LoadConfigObjects(StaticWeaponDefObjects, StaticWeaponObjects);
	class'ZedternalReborn.Config_WeaponVariant'.static.LoadConfigObjects(VariantProbs, VarBaseWeaponDefObjects,
		VarRepWeaponDefObjects, VarDualWeaponDefObjects);
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
