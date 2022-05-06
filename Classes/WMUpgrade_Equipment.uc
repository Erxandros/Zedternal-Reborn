class WMUpgrade_Equipment extends WMUpgrade
	abstract;

//Set LocalizeDescriptionLines to the number of upgrade description lines that need to be localized if bShouldLocalize is set to True.
var byte LocalizeDescriptionLineCount;

struct SEquipmentBonus
{
	var int baseValue;
	var int incValue;
	var int maxValue;
};
var array<SEquipmentBonus> EquipmentBonus;

static function string GetBonusValue(int Index, int Level)
{
	if (default.EquipmentBonus.length <= Index)
		return "";
	else
	{
		if (default.EquipmentBonus[Index].maxValue == -1)
			return string(default.EquipmentBonus[Index].baseValue + default.EquipmentBonus[Index].incValue * Level);
		else
			return string(Min(default.EquipmentBonus[Index].baseValue + default.EquipmentBonus[Index].incValue * Level, default.EquipmentBonus[Index].maxValue));
	}
}

static function string GetUpgradeDescription(byte Line)
{
	return GetUpgradeLocalization("EquipmentUpgradeDescription" $ (Line + 1));
}

defaultproperties
{
	UpgradeName="Default Equipment Upgrade Name"
	UpgradeDescription(0)="Default Equipment Description"

	Name="Default__WMUpgrade_Equipment"
}
