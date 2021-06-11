class WMUpgrade_Equipment extends WMUpgrade
	abstract;

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

defaultproperties
{
	upgradeName="default"
	upgradeDescription(0)="default description"

	Name="Default__WMUpgrade_Equipment"
}
