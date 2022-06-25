class WMWeaponConstants extends Object;

static function bool IsGrenadeDT(class<KFDamageType> DT, optional class<KFWeaponDefinition> GreandeDef)
{
	if (DT != None && DT.default.WeaponDef != None && GreandeDef != None)
		return DT.default.WeaponDef == GreandeDef;
	else
		return ClassIsChildOf(DT, class'KFDT_EMP_EMPGrenade')
		|| ClassIsChildOf(DT, class'KFDT_Explosive_DynamiteGrenade')
		|| ClassIsChildOf(DT, class'KFDT_Explosive_FlashBangGrenade')
		|| ClassIsChildOf(DT, class'KFDT_Explosive_FragGrenade')
		|| ClassIsChildOf(DT, class'KFDT_Explosive_HEGrenade')
		|| ClassIsChildOf(DT, class'KFDT_Explosive_NailBombGrenade')
		|| ClassIsChildOf(DT, class'KFDT_Fire_Ground_MolotovGrenade')
		|| ClassIsChildOf(DT, class'KFDT_Fire_MolotovGrenade')
		|| ClassIsChildOf(DT, class'KFDT_Freeze_FreezeGrenade')
		|| ClassIsChildOf(DT, class'KFDT_Piercing_NadeFragment')
		|| ClassIsChildOf(DT, class'KFDT_Piercing_NailFragment')
		|| ClassIsChildOf(DT, class'KFDT_Toxic_MedicGrenade');
}

defaultproperties
{
	Name="Default__WMWeaponConstants"
}
