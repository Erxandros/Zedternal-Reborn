class WMUpgrade_Perk extends WMUpgrade
	abstract;

struct SPerkBonus
{
	var int baseValue;
	var int incValue;
	var int maxValue;
};
var array<SPerkBonus> PerkBonus;

static function string GetBonusValue(int Index, int Level)
{
	if (default.PerkBonus.length <= Index)
		return "";
	else
	{
		if (default.PerkBonus[Index].maxValue == -1)
			return string(default.PerkBonus[Index].baseValue + default.PerkBonus[Index].incValue * Level);
		else
			return string(Min(default.PerkBonus[Index].baseValue + default.PerkBonus[Index].incValue * Level, default.PerkBonus[Index].maxValue));
	}
}

defaultproperties
{
	upgradeName="default"
	upgradeDescription(0)="default"

	Name="Default__WMUpgrade_Perk"
}
