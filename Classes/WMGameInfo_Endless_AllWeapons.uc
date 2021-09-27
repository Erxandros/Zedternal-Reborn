class WMGameInfo_Endless_AllWeapons extends WMGameInfo_Endless;

function PickWeapons(out array<int> WeaponIndex, int Begin)
{
	local int i;

	for (i = 0; i < WeaponIndex.Length; ++i)
	{
		AddWeaponInTrader(TraderItems.SaleItems[WeaponIndex[i]].WeaponDef);
	}
}

function int CombineWeaponsStartingWeapon(out array<S_Weapon_Data> CombinedWeaponList, out array< class<KFWeaponDefinition> > BaseWepDef,
	out array< class<KFWeapon> > BaseWep)
{
	local int i;

	for (i = 0; i < ConfigInit.StartingWeaponObjects.Length; ++i)
	{
		StartingWeaponPath.AddItem(PathName(ConfigInit.StartingWeaponObjects[i]));
	}

	CombineWeapons(CombinedWeaponList, ConfigInit.StartingWeaponDefObjects, ConfigInit.StartingWeaponObjects);

	return ConfigInit.StartingWeaponDefObjects.Length;
}

defaultproperties
{
	GameReplicationInfoClass=Class'ZedternalReborn.WMGameReplicationInfo_AllWeapons'
}
