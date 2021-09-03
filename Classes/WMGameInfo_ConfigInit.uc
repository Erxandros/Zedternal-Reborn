class WMGameInfo_ConfigInit extends Object;

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
	class'ZedternalReborn.Config_PerkUpgrade'.static.LoadConfigObjects(ValidPerkUpgrades, LoadedPerkUpgObjects);
	class'ZedternalReborn.Config_SkillUpgrade'.static.LoadConfigObjects(ValidSkillUpgrades, LoadedSkillUpgObjects);
	class'ZedternalReborn.Config_WeaponUpgrade'.static.LoadConfigObjects(ValidWeaponUpgrades, LoadedWeaponUpgObjects);
	class'ZedternalReborn.Config_EquipmentUpgrade'.static.LoadConfigObjects(ValidEquipmentUpgrades, LoadedEquipmentUpgObjects);
}

defaultproperties
{
	Name="Default__WMGameInfo_ConfigInit"
}
