class WMGameInfo_Endless_AllWeapons extends WMGameInfo_Endless;

function PickWeapons(out array<int> WeaponIndex)
{
	local int i;

	for (i = 0; i < WeaponIndex.Length; ++i)
	{
		AddWeaponInTrader(TraderItems.SaleItems[WeaponIndex[i]].WeaponDef);
	}
}

function CombineWeaponsStartingWeapon(out array<S_Weapon_Data> CombinedWeaponList, out array< class<KFWeaponDefinition> > IgnoreList)
{
	local int i;

	for (i = 0; i < ConfigData.StartingWeaponObjects.Length; ++i)
	{
		StartingWeaponPath.AddItem(PathName(ConfigData.StartingWeaponObjects[i]));
	}

	CombineWeapons(CombinedWeaponList, ConfigData.StartingWeaponDefObjects, ConfigData.StartingWeaponObjects);
}

defaultproperties
{
	GameReplicationInfoClass=Class'ZedternalReborn.WMGameReplicationInfo_AllWeapons'
}
